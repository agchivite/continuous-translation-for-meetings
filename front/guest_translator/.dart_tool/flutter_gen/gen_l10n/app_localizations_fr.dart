import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Salle de Traduction';

  @override
  String get checkRoom => 'Vérifier la salle';

  @override
  String get roomNotFound => 'Salle non trouvée';

  @override
  String get waitingForData => 'En attente des données...';

  @override
  String get english => 'Anglais';

  @override
  String get spanish => 'Espagnol';

  @override
  String get host => 'Hôte';

  @override
  String get guest => 'Invité';

  @override
  String get languageToTranslate => 'Langue à traduire:';

  @override
  String get languageOfVoice => 'Langue de la voix:';

  @override
  String get hostRoom => 'Salle de l\'hôte';

  @override
  String get guestRoom => 'Salle de l\'invité';

  @override
  String get translationRoom => 'Salle de traduction';

  @override
  String get roomCode => 'Code de la salle:';

  @override
  String get roomExists => 'La salle existe.';

  @override
  String get roomDoesNotExist => 'La salle n\'existe pas.';

  @override
  String get generateRoom => 'Générer une salle';

  @override
  String get leaveRoom => 'Quitter la salle';

  @override
  String get enterRoomId => 'Entrer l\'ID de la salle';

  @override
  String get joinRoom => 'Rejoindre';

  @override
  String get voiceLanguage => 'Langue de la voix:';

  @override
  String get websocketConnectionClosed => 'Connexion à la salle fermée.';

  @override
  String get connectionRoomEstablished => 'Connexion établie avec la salle: ';

  @override
  String get websocketError => 'Erreur WebSocket: ';

  @override
  String get hostMustProvideCode => 'L\'hôte doit fournir le code de la salle.';
}
