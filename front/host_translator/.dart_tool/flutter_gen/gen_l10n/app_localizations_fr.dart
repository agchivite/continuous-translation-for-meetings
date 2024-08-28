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
  String get failedRoomGeneration => 'Échec de la génération de la salle';

  @override
  String get mute => 'En sourdine';

  @override
  String get listening => 'Écoute...';

  @override
  String get canTalk => 'Vous pouvez parler...';

  @override
  String get inputSpeechLanguage => 'Langue de la voix d\'entrée:';

  @override
  String get english => 'Anglais';

  @override
  String get spanish => 'Espagnol';

  @override
  String get disableNotifications => 'Désactivez les notifications pour éviter le son d\'activation du microphone.';

  @override
  String get recommendWebComputer => 'Pour utiliser correctement les services de l\'hôte: \n \n  1. Vous devez utiliser le navigateur Chrome.\n \n  2. Vous devez entrer ce lien chrome://flags/#unsafely-treat-insecure-origin-as-secure, cette adresse web: http://wewiza.ddns.net/';
}
