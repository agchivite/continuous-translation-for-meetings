import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static final FlutterTts flutterTts = FlutterTts();

  static Future<List<dynamic>> getLanguages() async {
    List<dynamic> languages = await flutterTts.getLanguages;
    return languages;
  }

  static Future<void> speak(String text, String language) async {
    await flutterTts.setLanguage(language);
    await flutterTts.setPitch(0.8); // Like asian -> 0.8
    await flutterTts.setSpeechRate(0.5); // Voice speed
    await flutterTts.speak(text);
  }
}
