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
  String get failedRoomGeneration => '生成房间失败';

  @override
  String get mute => '静音';

  @override
  String get listening => '正在听...';

  @override
  String get canTalk => '可以说话...';

  @override
  String get inputSpeechLanguage => '输入语音语言:';

  @override
  String get english => '英语';

  @override
  String get spanish => '西班牙语';

  @override
  String get disableNotifications => '禁用通知以避免麦克风激活声音。';

  @override
  String get recommendWebComputer => '正确使用主持人服务：\n \n  1. 必须使用Chrome浏览器。\n \n  2. 必须在此链接chrome://flags/#unsafely-treat-insecure-origin-as-secure中输入此网址: http://wewiza.ddns.net/';

  @override
  String get v1recommendWebComputer => '要正确使用托管服务，您必须使用 Chrome 浏览器。';
}
