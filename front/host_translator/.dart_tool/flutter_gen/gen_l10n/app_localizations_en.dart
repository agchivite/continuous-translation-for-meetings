import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Translation Room';

  @override
  String get checkRoom => 'Check Room';

  @override
  String get roomNotFound => 'Room not found';

  @override
  String get waitingForData => 'Waiting for data...';

  @override
  String get host => 'Host';

  @override
  String get guest => 'Guest';

  @override
  String get languageToTranslate => 'Language to translate:';

  @override
  String get languageOfVoice => 'Language of voice:';

  @override
  String get hostRoom => 'Host Room';

  @override
  String get guestRoom => 'Guest Room';

  @override
  String get translationRoom => 'Translation Room';

  @override
  String get roomCode => 'Room code:';

  @override
  String get roomExists => 'Room exists.';

  @override
  String get roomDoesNotExist => 'Room does not exist.';

  @override
  String get generateRoom => 'Generate Room';

  @override
  String get failedRoomGeneration => 'Failed to generate room';

  @override
  String get mute => 'Muted';

  @override
  String get listening => 'Listening...';

  @override
  String get canTalk => 'Can talk...';

  @override
  String get inputSpeechLanguage => 'Input speech language:';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get disableNotifications => 'Turn off notifications to avoid the microphone wake-up sound.';

  @override
  String get recommendWebComputer => 'To properly use the host services: \n \n   1. You must use the Chrome browser.\n \n   2. You must enter this web address: http://wewiza.ddns.net/ at the following link chrome://flags/#unsafely-treat-insecure-origin-as-secure.';
}
