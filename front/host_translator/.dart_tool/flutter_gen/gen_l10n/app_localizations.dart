import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('vi'),
    Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', countryCode: 'HK', scriptCode: 'Hant'),
    Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW', scriptCode: 'Hant'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Translation Room'**
  String get appTitle;

  /// No description provided for @checkRoom.
  ///
  /// In en, this message translates to:
  /// **'Check Room'**
  String get checkRoom;

  /// No description provided for @roomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Room not found'**
  String get roomNotFound;

  /// No description provided for @waitingForData.
  ///
  /// In en, this message translates to:
  /// **'Waiting for data...'**
  String get waitingForData;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @languageToTranslate.
  ///
  /// In en, this message translates to:
  /// **'Language to translate:'**
  String get languageToTranslate;

  /// No description provided for @languageOfVoice.
  ///
  /// In en, this message translates to:
  /// **'Language of voice:'**
  String get languageOfVoice;

  /// No description provided for @hostRoom.
  ///
  /// In en, this message translates to:
  /// **'Host Room'**
  String get hostRoom;

  /// No description provided for @guestRoom.
  ///
  /// In en, this message translates to:
  /// **'Guest Room'**
  String get guestRoom;

  /// No description provided for @translationRoom.
  ///
  /// In en, this message translates to:
  /// **'Translation Room'**
  String get translationRoom;

  /// No description provided for @roomCode.
  ///
  /// In en, this message translates to:
  /// **'Room code:'**
  String get roomCode;

  /// No description provided for @roomExists.
  ///
  /// In en, this message translates to:
  /// **'Room exists.'**
  String get roomExists;

  /// No description provided for @roomDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'Room does not exist.'**
  String get roomDoesNotExist;

  /// No description provided for @generateRoom.
  ///
  /// In en, this message translates to:
  /// **'Generate Room'**
  String get generateRoom;

  /// No description provided for @failedRoomGeneration.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate room'**
  String get failedRoomGeneration;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get mute;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @canTalk.
  ///
  /// In en, this message translates to:
  /// **'You can talk...'**
  String get canTalk;

  /// No description provided for @inputSpeechLanguage.
  ///
  /// In en, this message translates to:
  /// **'Input speech language:'**
  String get inputSpeechLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @closeRoom.
  ///
  /// In en, this message translates to:
  /// **'Close Room'**
  String get closeRoom;

  /// No description provided for @disableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Turn off notifications to avoid the microphone wake-up sound.'**
  String get disableNotifications;

  /// No description provided for @recommendWebComputer.
  ///
  /// In en, this message translates to:
  /// **'To properly use the host services: \n \n   1. You must use the Chrome browser.\n \n   2. You must enter this web address: http://wewiza.ddns.net/ at the following link chrome://flags/#unsafely-treat-insecure-origin-as-secure.'**
  String get recommendWebComputer;

  /// No description provided for @v1recommendWebComputer.
  ///
  /// In en, this message translates to:
  /// **'To properly use the hosting services, you must use the Chrome browser.'**
  String get v1recommendWebComputer;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'it', 'ja', 'ko', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
    // Lookup logic when language+script+country codes are specified.
  switch (locale.toString()) {
    case 'zh_Hans_CN': return AppLocalizationsZhHansCn();
        case 'zh_Hant_HK': return AppLocalizationsZhHantHk();
        case 'zh_Hant_TW': return AppLocalizationsZhHantTw();
  }


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
