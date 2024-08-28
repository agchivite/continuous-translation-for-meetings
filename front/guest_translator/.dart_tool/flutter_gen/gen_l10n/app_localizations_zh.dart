import 'app_localizations.dart';

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '翻译室';

  @override
  String get checkRoom => '检查房间';

  @override
  String get roomNotFound => '房间未找到';

  @override
  String get waitingForData => '等待数据...';

  @override
  String get english => '英语';

  @override
  String get spanish => '西班牙语';

  @override
  String get host => '主持人';

  @override
  String get guest => '客人';

  @override
  String get languageToTranslate => '翻译语言:';

  @override
  String get languageOfVoice => '语音语言:';

  @override
  String get hostRoom => '主持人房间';

  @override
  String get guestRoom => '客人房间';

  @override
  String get translationRoom => '翻译室';

  @override
  String get roomCode => '房间代码:';

  @override
  String get roomExists => '房间存在。';

  @override
  String get roomDoesNotExist => '房间不存在。';

  @override
  String get generateRoom => '生成房间';

  @override
  String get leaveRoom => '离开房间';

  @override
  String get enterRoomId => '输入房间ID';

  @override
  String get joinRoom => '加入';

  @override
  String get voiceLanguage => '语音语言:';

  @override
  String get websocketConnectionClosed => '与房间的连接已关闭。';

  @override
  String get connectionRoomEstablished => '与房间的连接已建立: ';

  @override
  String get websocketError => 'WebSocket 错误: ';

  @override
  String get hostMustProvideCode => '主持人必须提供房间代码。';
}
