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
  String get english => '영어';

  @override
  String get spanish => '스페인어';

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
  String get leaveRoom => '방 나가기';

  @override
  String get enterRoomId => '방 ID 입력';

  @override
  String get joinRoom => '참여';

  @override
  String get voiceLanguage => '음성 언어:';

  @override
  String get websocketConnectionClosed => '방과의 연결이 종료되었습니다.';

  @override
  String get connectionRoomEstablished => '방과의 연결이 설정되었습니다: ';

  @override
  String get websocketError => 'WebSocket 오류: ';

  @override
  String get hostMustProvideCode => '호스트는 방 코드를 제공해야 합니다.';
}
