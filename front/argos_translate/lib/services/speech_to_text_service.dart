import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognition {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  bool get isListening => _isListening;

  void startListening(Function(String) onResult) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onError: (error) => print('Error: $error'),
        onStatus: (status) {
          _isListening = status == 'listening';
        },
      );

      if (available) {
        _speech.listen(
          onResult: (result) {
            onResult(result.recognizedWords);
          },
          listenFor: Duration(minutes: 1),
          pauseFor: Duration(minutes: 5),
          partialResults: true,
          onSoundLevelChange: (level) => print('Sound level: $level'),
        );
      }
    }
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }
}
