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
  String get english => '英語';

  @override
  String get spanish => 'スペイン語';

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
  String get leaveRoom => 'ルームを退出';

  @override
  String get enterRoomId => 'ルームIDを入力';

  @override
  String get joinRoom => '参加';

  @override
  String get voiceLanguage => '音声の言語:';

  @override
  String get websocketConnectionClosed => 'ルームへの接続が閉じました。';

  @override
  String get connectionRoomEstablished => 'ルームへの接続が確立しました: ';

  @override
  String get websocketError => 'WebSocketエラー: ';

  @override
  String get hostMustProvideCode => 'ホストはルームコードを提供する必要があります。';
}
