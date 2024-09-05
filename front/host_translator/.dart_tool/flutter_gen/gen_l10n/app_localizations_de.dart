import 'app_localizations.dart';

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Übersetzungsraum';

  @override
  String get checkRoom => 'Raum überprüfen';

  @override
  String get roomNotFound => 'Raum nicht gefunden';

  @override
  String get waitingForData => 'Warten auf Daten...';

  @override
  String get host => 'Gastgeber';

  @override
  String get guest => 'Gast';

  @override
  String get languageToTranslate => 'Zu übersetzende Sprache:';

  @override
  String get languageOfVoice => 'Sprache der Stimme:';

  @override
  String get hostRoom => 'Gastgeberzimmer';

  @override
  String get guestRoom => 'Gästezimmer';

  @override
  String get translationRoom => 'Übersetzungsraum';

  @override
  String get roomCode => 'Raumcode:';

  @override
  String get roomExists => 'Der Raum existiert.';

  @override
  String get roomDoesNotExist => 'Der Raum existiert nicht.';

  @override
  String get generateRoom => 'Raum erzeugen';

  @override
  String get failedRoomGeneration => 'Raumerzeugung fehlgeschlagen';

  @override
  String get mute => 'Stumm';

  @override
  String get listening => 'Hören...';

  @override
  String get canTalk => 'Sie können sprechen...';

  @override
  String get inputSpeechLanguage => 'Eingabesprache der Stimme:';

  @override
  String get english => 'Englisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get disableNotifications => 'Deaktivieren Sie Benachrichtigungen, um das Mikrofonaktivierungsgeräusch zu vermeiden.';

  @override
  String get recommendWebComputer => 'Um die Gastgeberdienste ordnungsgemäß zu nutzen: \n \n  1. Sie müssen den Chrome-Browser verwenden.\n \n  2. Sie müssen diesen Link chrome://flags/#unsafely-treat-insecure-origin-as-secure in diese Webadresse eingeben: http://wewiza.ddns.net/';

  @override
  String get v1recommendWebComputer => 'Um die Host-Dienste korrekt zu nutzen, müssen Sie den Chrome-Browser verwenden.';
}
