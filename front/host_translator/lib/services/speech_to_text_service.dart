import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognition {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  bool get isListening => _isListening;

  Future<List<stt.LocaleName>> getLocales() async {
    return await _speech.locales();
  }

  void startListening(Function(String) onResult, {String? localeId}) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onError: (error) => print('Error: $error'),
        onStatus: (status) {
          _isListening = status == 'listening';

          // If the recognition is stopped, restart immediately
          if (status == 'notListening') {
            _startListening(onResult, localeId: localeId);
          }
        },
      );

      if (available) {
        _startListening(onResult, localeId: localeId);
      }
    }
  }

  void _startListening(Function(String) onResult, {String? localeId}) {
    _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      listenFor: Duration(minutes: 1),
      pauseFor: Duration(minutes: 5),
      partialResults: true,
      localeId: localeId,
      onSoundLevelChange: (level) => print('Sound level: $level'),
    );
    _isListening = true;
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }

  void dispose() {
    _speech.stop();
  }
}
