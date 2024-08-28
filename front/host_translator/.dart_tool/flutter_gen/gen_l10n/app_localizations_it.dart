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
  String get failedRoomGeneration => 'Generazione stanza fallita';

  @override
  String get mute => 'Silenzioso';

  @override
  String get listening => 'Ascoltando...';

  @override
  String get canTalk => 'Può parlare...';

  @override
  String get inputSpeechLanguage => 'Lingua della voce in ingresso:';

  @override
  String get english => 'Inglese';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get disableNotifications => 'Disabilita le notifiche per evitare il suono di attivazione del microfono.';

  @override
  String get recommendWebComputer => 'Per utilizzare correttamente i servizi dell\'ospitante: \n \n  1. È necessario utilizzare il browser Chrome.\n \n  2. È necessario inserire questo link chrome://flags/#unsafely-treat-insecure-origin-as-secure in questo indirizzo web: http://wewiza.ddns.net/';
}
