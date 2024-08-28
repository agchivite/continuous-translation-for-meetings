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
  String get english => 'Englisch';

  @override
  String get spanish => 'Spanisch';

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
  String get generateRoom => 'Raum erstellen';

  @override
  String get leaveRoom => 'Raum verlassen';

  @override
  String get enterRoomId => 'Raum-ID eingeben';

  @override
  String get joinRoom => 'Beitreten';

  @override
  String get voiceLanguage => 'Sprache der Stimme:';

  @override
  String get websocketConnectionClosed => 'Verbindung zum Raum geschlossen.';

  @override
  String get connectionRoomEstablished => 'Verbindung zum Raum hergestellt: ';

  @override
  String get websocketError => 'WebSocket-Fehler: ';

  @override
  String get hostMustProvideCode => 'Der Gastgeber muss den Raumcode angeben.';
}
