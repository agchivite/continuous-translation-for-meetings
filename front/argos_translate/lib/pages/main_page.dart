import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../views/guest_view.dart';
import '../views/host_view.dart';

class MainPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const MainPage({super.key, required this.onLocaleChange});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  Locale _selectedLocale = Locale('en');

  final List<Widget> _screens = [
    const HostView(),
    const GuestView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translationRoom),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<Locale>(
              underline: const SizedBox(),
              icon: const Icon(Icons.language, color: Colors.blueGrey),
              onChanged: (Locale? locale) {
                if (locale != null) {
                  setState(() {
                    _selectedLocale = locale;
                  });
                  widget.onLocaleChange(locale);
                }
              },
              value: _selectedLocale,
              selectedItemBuilder: (BuildContext context) {
                return [
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.english,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.spanish,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ];
              },
              items: [
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(AppLocalizations.of(context)!.english),
                ),
                DropdownMenuItem(
                  value: const Locale('es'),
                  child: Text(AppLocalizations.of(context)!.spanish),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.record_voice_over),
            label: AppLocalizations.of(context)!.host,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_box_rounded),
            label: AppLocalizations.of(context)!.guest,
          ),
        ],
      ),
    );
  }
}
