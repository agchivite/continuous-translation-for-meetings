import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageDropdown extends StatelessWidget {
  final Locale selectedLocale;
  final Function(Locale) onLocaleChange;

  LanguageDropdown({
    required this.selectedLocale,
    required this.onLocaleChange,
    super.key,
  });

  final Map<String, String> _localeFlags = {
    'en': '🇺🇸',
    'es': '🇪🇸',
    'de': '🇩🇪',
    'fr': '🇫🇷',
    'it': '🇮🇹',
    'ja': '🇯🇵',
    'ko': '🇰🇷',
    'vi': '🇻🇳',
    'zh': '🇨🇳'
  };

  /*
  'zh-Hans': '🇨🇳',
    'zh-Hant': '🇹🇼'
   */

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: selectedLocale,
      onChanged: (Locale? locale) {
        if (locale != null) {
          onLocaleChange(locale);
        }
      },
      items: AppLocalizations.supportedLocales.map((Locale locale) {
        String flag = _localeFlags[locale.languageCode] ?? '🌍';

        return DropdownMenuItem<Locale>(
          value: locale,
          child: Row(
            children: [
              Text(
                flag,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                locale.languageCode.toUpperCase(),
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
