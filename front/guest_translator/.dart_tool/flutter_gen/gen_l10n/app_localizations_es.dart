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
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

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
  String get leaveRoom => 'Salir de la habitación';

  @override
  String get enterRoomId => 'Introduce el ID de la habitación';

  @override
  String get joinRoom => 'Entrar';

  @override
  String get voiceLanguage => 'Lenguaje de voz:';

  @override
  String get websocketConnectionClosed => 'Conexión con la habitación cerrada.';

  @override
  String get connectionRoomEstablished => 'Conexión establecida con la habitación: ';

  @override
  String get websocketError => 'Error de WebSocket: ';

  @override
  String get hostMustProvideCode => 'El anfitrión debe indicar el código de la habitación.';
}
