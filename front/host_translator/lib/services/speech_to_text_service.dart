import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognition {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isInitialized = false;
  bool _isMuted = false;
  Timer? _restartTimer;
  Function(String)? _onResultCallback;
  Function(bool)? _onListeningStateChanged;
  String? _currentLocaleId;

  bool get isListening => _isListening;

  Future<List<stt.LocaleName>> getLocales() async {
    return await _speech.locales();
  }

  Future<void> startListening(
    Function(String) onResult, {
    String? localeId,
    Function(bool)? onListeningStateChanged,
  }) async {
    if (_isMuted) return;

    _onResultCallback = onResult;
    _currentLocaleId = localeId;
    _onListeningStateChanged = onListeningStateChanged;

    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onError: (error) => print('Error: $error'),
        onStatus: (status) {
          print('Speech recognition status: $status');
          if (status == 'done' || status == 'notListening') {
            _setListeningState(false);
            _restartListening();
          } else if (status == 'listening') {
            _setListeningState(true);
          }
        },
      );
    }

    if (_isInitialized) {
      await _startListeningInternal();
    } else {
      print('Speech recognition not initialized');
    }
  }

  Future<void> _startListeningInternal() async {
    if (_isMuted || _isListening) {
      print('Already listening or muted, skipping start');
      return;
    }

    try {
      await _speech.stop();

      final bool? started = await _speech.listen(
        onResult: (result) {
          _onResultCallback?.call(result.recognizedWords);
          if (result.recognizedWords.isNotEmpty) {
            _setListeningState(true);
          }
        },
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 3),
        partialResults: true,
        localeId: _currentLocaleId,
        onSoundLevelChange: (level) {
          print('Sound level: $level');
        },
      );
      _setListeningState(started ?? false);
      print('Listening started: ${started ?? false}');
    } catch (e) {
      print('Error starting to listen: $e');
      _setListeningState(false);
      _restartListening();
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _setListeningState(false);
    }
    _restartTimer?.cancel();
    print('Listening stopped');
  }

  Future<void> stopAndRestartListening() async {
    await stopListening();
    await Future.delayed(Duration(milliseconds: 300));
    await _startListeningInternal();
  }

  void _restartListening() {
    if (_isMuted) return;
    _restartTimer?.cancel();
    _restartTimer = Timer(Duration(milliseconds: 300), () async {
      print('Restarting listening...');
      await _startListeningInternal();
    });
  }

  void _setListeningState(bool listening) {
    _isListening = listening;
    _onListeningStateChanged?.call(listening);
  }

  void dispose() {
    _speech.stop();
    _isInitialized = false;
    _restartTimer?.cancel();
  }

  void setMuted(bool isMuted) {
    _isMuted = isMuted;
    if (_isMuted) {
      stopListening();
    } else {
      _restartListening();
    }
  }
}
