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
    'zh': '🇨🇳',
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: selectedLocale,
      onChanged: (Locale? locale) {
        if (locale != null) {
          onLocaleChange(locale);
        }
      },

      // Filter to omit 'zh' without scriptCode
      items: AppLocalizations.supportedLocales
          .where((locale) =>
              locale.languageCode != 'zh' || locale.scriptCode != null)
          .map((Locale locale) {
        String flag = _localeFlags[locale.languageCode] ?? '🌍';

        String localeDisplay = locale.languageCode.toUpperCase();
        if (locale.scriptCode != null) {
          localeDisplay += '_${locale.scriptCode!.toUpperCase()}';
        }
        if (locale.countryCode != null) {
          localeDisplay += '_${locale.countryCode!.toUpperCase()}';
        }

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
                localeDisplay,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
