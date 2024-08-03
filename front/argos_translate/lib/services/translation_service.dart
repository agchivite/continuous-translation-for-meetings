import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class TranslationService {
  static Future<String?> translateText(String text, String language) async {
    try {
      final url = Uri.parse('$baseUrl/translate/$language?text=$text');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final decodedJson = json.decode(utf8Response);
        final translatedText = decodedJson['translated_text'];
        return translatedText;
      } else {
        print('Failed to translate text: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error translating text: $e');
      return null;
    }
  }

  static Future<List<String>> getTranslationLanguages() async {
    try {
      final url = Uri.parse('$baseUrl/languages');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final decodedJson = json.decode(utf8Response);
        Map<String, dynamic> languagesMap = decodedJson['languages'];
        List<String> languages = languagesMap.keys.toList();
        return languages;
      } else {
        print('Failed to fetch translation languages: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching translation languages: $e');
      return [];
    }
  }
}
