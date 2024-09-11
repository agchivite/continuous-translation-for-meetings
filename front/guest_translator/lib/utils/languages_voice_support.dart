import 'language.dart';

class LanguageVoiceList {
  final _langs = {
    'ar': 'Arabic',
    'as-IN': 'Assamese (India)',
    'bg-BG': 'Bulgarian',
    'bn-BD': 'Bengali (Bangladesh)',
    'bn-IN': 'Bengali (India)',
    'brx-IN': 'Bodo (India)',
    'bs-BA': 'Bosnian',
    'ca-ES': 'Catalan',
    'cs-CZ': 'Czech',
    'cy-GB': 'Welsh',
    'da-DK': 'Danish',
    'de-DE': 'German',
    'doi-IN': 'Dogri (India)',
    'el-GR': 'Greek',
    'en-AU': 'English (Australia)',
    'en-GB': 'English (United Kingdom)',
    'en-IN': 'English (India)',
    'en-NG': 'English (Nigeria)',
    'en-US': 'English (United States)',
    'es-ES': 'Spanish (Spain)',
    'es-US': 'Spanish (United States)',
    'et-EE': 'Estonian',
    'fi-FI': 'Finnish',
    'fil-PH': 'Filipino (Philippines)',
    'fr-CA': 'French (Canada)',
    'fr-FR': 'French (France)',
    'gu-IN': 'Gujarati (India)',
    'he-IL': 'Hebrew',
    'hi-IN': 'Hindi (India)',
    'hr-HR': 'Croatian',
    'hu-HU': 'Hungarian',
    'id-ID': 'Indonesian',
    'is-IS': 'Icelandic',
    'it-IT': 'Italian',
    'ja-JP': 'Japanese',
    'jv-ID': 'Javanese (Indonesia)',
    'km-KH': 'Khmer',
    'kn-IN': 'Kannada (India)',
    'ko-KR': 'Korean',
    'kok-IN': 'Konkani (India)',
    'ks-IN': 'Kashmiri (India)',
    'lt-LT': 'Lithuanian',
    'lv-LV': 'Latvian',
    'mai-IN': 'Maithili (India)',
    'ml-IN': 'Malayalam (India)',
    'mni-IN': 'Manipuri (India)',
    'mr-IN': 'Marathi (India)',
    'ms-MY': 'Malay (Malaysia)',
    'nb-NO': 'Norwegian (Bokmål)',
    'ne-NP': 'Nepali',
    'nl-BE': 'Dutch (Belgium)',
    'nl-NL': 'Dutch (Netherlands)',
    'or-IN': 'Odia (India)',
    'pa-IN': 'Punjabi (India)',
    'pl-PL': 'Polish',
    'pt-BR': 'Portuguese (Brazil)',
    'pt-PT': 'Portuguese (Portugal)',
    'ro-RO': 'Romanian',
    'ru-RU': 'Russian',
    'sa-IN': 'Sanskrit (India)',
    'sat-IN': 'Santali (India)',
    'sd-IN': 'Sindhi (India)',
    'si-LK': 'Sinhala',
    'sk-SK': 'Slovak',
    'sl-SI': 'Slovenian',
    'sq-AL': 'Albanian',
    'sr-RS': 'Serbian',
    'su-ID': 'Sundanese (Indonesia)',
    'sv-SE': 'Swedish',
    'sw-KE': 'Swahili (Kenya)',
    'ta-IN': 'Tamil (India)',
    'te-IN': 'Telugu (India)',
    'th-TH': 'Thai',
    'tr-TR': 'Turkish',
    'uk-UA': 'Ukrainian',
    'ur-PK': 'Urdu (Pakistan)',
    'vi-VN': 'Vietnamese',
    'yue-HK': 'Cantonese (Hong Kong)',
    'zh-CN': 'Chinese (Simplified)',
    'zh-TW': 'Chinese (Traditional)',
  };

  List<String> getAllConcatenated() {
    List<String> filteredLanguages =
        _langs.entries.map((entry) => '${entry.key} - ${entry.value}').toList();

    filteredLanguages.sort((a, b) => a.compareTo(b));

    return filteredLanguages;
  }

  String extractLanguageCode(String concatenatedString) {
    return concatenatedString.split(' - ').first;
  }

  List<Language> getAll() {
    return _langs.entries.map((entry) {
      return Language(entry.key, entry.value);
    }).toList();
  }
}
