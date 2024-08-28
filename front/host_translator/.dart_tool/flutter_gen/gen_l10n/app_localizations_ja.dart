import 'app_localizations.dart';

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '翻訳ルーム';

  @override
  String get checkRoom => 'ルームを確認';

  @override
  String get roomNotFound => 'ルームが見つかりません';

  @override
  String get waitingForData => 'データ待機中...';

  @override
  String get host => 'ホスト';

  @override
  String get guest => 'ゲスト';

  @override
  String get languageToTranslate => '翻訳する言語:';

  @override
  String get languageOfVoice => '音声の言語:';

  @override
  String get hostRoom => 'ホストルーム';

  @override
  String get guestRoom => 'ゲストルーム';

  @override
  String get translationRoom => '翻訳ルーム';

  @override
  String get roomCode => 'ルームコード:';

  @override
  String get roomExists => 'ルームが存在します。';

  @override
  String get roomDoesNotExist => 'ルームは存在しません。';

  @override
  String get generateRoom => 'ルームを生成';

  @override
  String get failedRoomGeneration => 'ルーム生成失敗';

  @override
  String get mute => 'ミュート';

  @override
  String get listening => '聞いています...';

  @override
  String get canTalk => '話せます...';

  @override
  String get inputSpeechLanguage => '入力音声言語:';

  @override
  String get english => '英語';

  @override
  String get spanish => 'スペイン語';

  @override
  String get disableNotifications => 'マイクの起動音を避けるため、通知を無効にしてください。';

  @override
  String get recommendWebComputer => 'ホストサービスを正しく使用するには： \n \n  1. Chromeブラウザを使用する必要があります。\n \n  2. このリンクchrome://flags/#unsafely-treat-insecure-origin-as-secureにこのウェブアドレスを入力する必要があります: http://wewiza.ddns.net/';
}
