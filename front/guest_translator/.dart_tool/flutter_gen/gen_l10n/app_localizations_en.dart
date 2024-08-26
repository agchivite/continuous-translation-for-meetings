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
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

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
  String get leaveRoom => 'Leave Room';

  @override
  String get enterRoomId => 'Enter Room ID';

  @override
  String get joinRoom => 'Join Room';

  @override
  String get voiceLanguage => 'Voice language:';

  @override
  String get websocketConnectionClosed => 'Room connection closed.';

  @override
  String get connectionRoomEstablished => 'Connection established with room: ';

  @override
  String get websocketError => 'WebSocket error: ';

  @override
  String get hostMustProvideCode => 'The host must provide the room code.';
}
