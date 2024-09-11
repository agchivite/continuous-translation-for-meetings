import 'package:flutter_tts/flutter_tts.dart';

import '../utils/languages_voice_support.dart';

class TextToSpeech {
  static final FlutterTts flutterTts = FlutterTts();

  static Future<List<dynamic>> getLanguages() async {
    // Last case getting languages from library with ONLY the CODE LANGUAGE
    /*List<dynamic> languages = await flutterTts.getLanguages;
    languages.sort((a, b) => a.toString().compareTo(b.toString()));*/

    // NEW language code to concatenate key - value
    var languageList = LanguageVoiceList();
    var languages = languageList.getAllConcatenated();
    return languages;
  }

  static Future<void> speak(String text, String language) async {
    await flutterTts.setLanguage(language);
    await flutterTts.setPitch(0.8); // Like asian -> 0.8
    await flutterTts.setSpeechRate(0.5); // Voice speed
    await flutterTts.speak(text);
  }
}
