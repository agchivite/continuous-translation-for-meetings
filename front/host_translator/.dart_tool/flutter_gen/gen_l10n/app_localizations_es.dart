import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Sala de Traducción';

  @override
  String get checkRoom => 'Comprobar sala';

  @override
  String get roomNotFound => 'Sala no encontrada';

  @override
  String get waitingForData => 'Esperando datos...';

  @override
  String get host => 'Anfitrión';

  @override
  String get guest => 'Invitado';

  @override
  String get languageToTranslate => 'Lenguaje para traducir:';

  @override
  String get languageOfVoice => 'Lenguaje de voz:';

  @override
  String get hostRoom => 'Habitación de anfitrión';

  @override
  String get guestRoom => 'Habitación de invitado';

  @override
  String get translationRoom => 'Habitación de traducción';

  @override
  String get roomCode => 'Código de habitación:';

  @override
  String get roomExists => 'La habitación existe.';

  @override
  String get roomDoesNotExist => 'La habitación no existe.';

  @override
  String get generateRoom => 'Generar habitación';

  @override
  String get failedRoomGeneration => 'Error al generar la habitación';

  @override
  String get mute => 'Silenciado';

  @override
  String get listening => 'Escuchando...';

  @override
  String get canTalk => 'Puede hablar...';

  @override
  String get inputSpeechLanguage => 'Lenguaje de voz de entrada:';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get disableNotifications => 'Turn off notifications to avoid the microphone wake-up sound.';

  @override
  String get recommendWebComputer => 'For a better experience, it is recommended to use it on a computer through a web browser.';
}
