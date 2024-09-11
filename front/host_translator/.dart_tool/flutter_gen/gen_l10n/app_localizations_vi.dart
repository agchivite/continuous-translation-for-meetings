import 'app_localizations.dart';

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Phòng Dịch';

  @override
  String get checkRoom => 'Kiểm tra phòng';

  @override
  String get roomNotFound => 'Không tìm thấy phòng';

  @override
  String get waitingForData => 'Đang chờ dữ liệu...';

  @override
  String get host => 'Chủ nhà';

  @override
  String get guest => 'Khách';

  @override
  String get languageToTranslate => 'Ngôn ngữ dịch:';

  @override
  String get languageOfVoice => 'Ngôn ngữ giọng nói:';

  @override
  String get hostRoom => 'Phòng chủ nhà';

  @override
  String get guestRoom => 'Phòng khách';

  @override
  String get translationRoom => 'Phòng dịch';

  @override
  String get roomCode => 'Mã phòng:';

  @override
  String get roomExists => 'Phòng tồn tại.';

  @override
  String get roomDoesNotExist => 'Phòng không tồn tại.';

  @override
  String get generateRoom => 'Tạo phòng';

  @override
  String get failedRoomGeneration => 'Tạo phòng thất bại';

  @override
  String get mute => 'Tắt tiếng';

  @override
  String get listening => 'Đang nghe...';

  @override
  String get canTalk => 'Bạn có thể nói...';

  @override
  String get inputSpeechLanguage => 'Ngôn ngữ giọng nói đầu vào:';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get spanish => 'Tiếng Tây Ban Nha';

  @override
  String get closeRoom => 'Đóng phòng';

  @override
  String get disableNotifications => 'Tắt thông báo để tránh âm thanh kích hoạt micrô.';

  @override
  String get recommendWebComputer => 'Để sử dụng đúng các dịch vụ chủ nhà: \n \n  1. Bạn phải sử dụng trình duyệt Chrome.\n \n  2. Bạn phải nhập liên kết này chrome://flags/#unsafely-treat-insecure-origin-as-secure, địa chỉ web này: http://wewiza.ddns.net/';

  @override
  String get v1recommendWebComputer => 'Để sử dụng đúng các dịch vụ lưu trữ, bạn phải sử dụng trình duyệt Chrome.';
}
