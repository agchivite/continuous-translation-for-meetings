import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognition {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isInitialized = false;
  Timer? _restartTimer;

  bool get isListening => _isListening;

  Future<List<stt.LocaleName>> getLocales() async {
    return await _speech.locales();
  }

  Future<void> startListening(Function(String) onResult,
      {String? localeId}) async {
    if (_isListening) {
      print('Already listening, stopping first');
      await stopListening();
    }

    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onError: (error) => print('Error: $error'),
        onStatus: (status) {
          print('Speech recognition status: $status');
          _isListening = status == 'listening';
          /*if (status == 'done') {
            _restartListening();
          }*/
        },
      );
    }

    if (_isInitialized) {
      try {
        // Handle potential null values
        final bool? result = await _speech.listen(
          onResult: (result) {
            onResult(result.recognizedWords);
          },
          listenFor: Duration(minutes: 15),
          // Adjust this duration if needed
          pauseFor: Duration(minutes: 15),
          partialResults: true,
          localeId: localeId,
          onSoundLevelChange: (level) => print('Sound level: $level'),
        );
        _isListening = result ?? false;
        print('Listening started: $_isListening');
      } catch (e) {
        print('Error starting to listen: $e');
        _isListening = false;
      }
    } else {
      print('Speech recognition not initialized');
    }
  }

  Future<void> stopListening() async {
    _isListening = false;
    await _speech.stop();
    _restartTimer?.cancel();
    print('Listening stopped');
  }

  void _restartListening() {
    _restartTimer?.cancel();
    _restartTimer = Timer(Duration(seconds: 1), () async {
      if (!_isListening) {
        print('Restarting listening...');
        await startListening((result) {});
      }
    });
  }

  void dispose() {
    _speech.stop();
    _isInitialized = false;
    _restartTimer?.cancel();
  }
}
