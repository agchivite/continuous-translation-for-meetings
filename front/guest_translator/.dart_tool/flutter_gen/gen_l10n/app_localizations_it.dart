import 'app_localizations.dart';

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Stanza di Traduzione';

  @override
  String get checkRoom => 'Verifica stanza';

  @override
  String get roomNotFound => 'Stanza non trovata';

  @override
  String get waitingForData => 'In attesa di dati...';

  @override
  String get english => 'Inglese';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get host => 'Ospitante';

  @override
  String get guest => 'Ospite';

  @override
  String get languageToTranslate => 'Lingua da tradurre:';

  @override
  String get languageOfVoice => 'Lingua della voce:';

  @override
  String get hostRoom => 'Stanza dell\'ospitante';

  @override
  String get guestRoom => 'Stanza dell\'ospite';

  @override
  String get translationRoom => 'Stanza di traduzione';

  @override
  String get roomCode => 'Codice della stanza:';

  @override
  String get roomExists => 'La stanza esiste.';

  @override
  String get roomDoesNotExist => 'La stanza non esiste.';

  @override
  String get generateRoom => 'Genera stanza';

  @override
  String get leaveRoom => 'Esci dalla stanza';

  @override
  String get enterRoomId => 'Inserisci l\'ID della stanza';

  @override
  String get joinRoom => 'Entra';

  @override
  String get voiceLanguage => 'Lingua della voce:';

  @override
  String get websocketConnectionClosed => 'Connessione con la stanza chiusa.';

  @override
  String get connectionRoomEstablished => 'Connessione stabilita con la stanza: ';

  @override
  String get websocketError => 'Errore WebSocket: ';

  @override
  String get hostMustProvideCode => 'L\'ospitante deve fornire il codice della stanza.';
}
