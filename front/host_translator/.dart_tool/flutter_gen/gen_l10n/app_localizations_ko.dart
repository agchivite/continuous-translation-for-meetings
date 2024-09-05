import 'app_localizations.dart';

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '번역방';

  @override
  String get checkRoom => '방 확인';

  @override
  String get roomNotFound => '방을 찾을 수 없음';

  @override
  String get waitingForData => '데이터 기다리는 중...';

  @override
  String get host => '호스트';

  @override
  String get guest => '게스트';

  @override
  String get languageToTranslate => '번역할 언어:';

  @override
  String get languageOfVoice => '음성 언어:';

  @override
  String get hostRoom => '호스트 방';

  @override
  String get guestRoom => '게스트 방';

  @override
  String get translationRoom => '번역 방';

  @override
  String get roomCode => '방 코드:';

  @override
  String get roomExists => '방이 존재합니다.';

  @override
  String get roomDoesNotExist => '방이 존재하지 않습니다.';

  @override
  String get generateRoom => '방 생성';

  @override
  String get failedRoomGeneration => '방 생성 실패';

  @override
  String get mute => '음소거';

  @override
  String get listening => '듣는 중...';

  @override
  String get canTalk => '말할 수 있습니다...';

  @override
  String get inputSpeechLanguage => '입력 음성 언어:';

  @override
  String get english => '영어';

  @override
  String get spanish => '스페인어';

  @override
  String get disableNotifications => '마이크 활성화 소리를 피하려면 알림을 비활성화하세요.';

  @override
  String get recommendWebComputer => '호스트 서비스를 제대로 사용하려면: \n \n  1. Chrome 브라우저를 사용해야 합니다.\n \n  2. 이 링크 chrome://flags/#unsafely-treat-insecure-origin-as-secure에 이 웹 주소를 입력해야 합니다: http://wewiza.ddns.net/';

  @override
  String get v1recommendWebComputer => '호스팅 서비스를 제대로 사용하려면 Chrome 브라우저를 사용해야 합니다.';
}
