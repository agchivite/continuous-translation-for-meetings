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
  String get english => 'Tiếng Anh';

  @override
  String get spanish => 'Tiếng Tây Ban Nha';

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
  String get leaveRoom => 'Rời khỏi phòng';

  @override
  String get enterRoomId => 'Nhập ID phòng';

  @override
  String get joinRoom => 'Tham gia';

  @override
  String get voiceLanguage => 'Ngôn ngữ giọng nói:';

  @override
  String get websocketConnectionClosed => 'Kết nối với phòng đã đóng.';

  @override
  String get connectionRoomEstablished => 'Kết nối được thiết lập với phòng: ';

  @override
  String get websocketError => 'Lỗi WebSocket: ';

  @override
  String get hostMustProvideCode => 'Chủ nhà phải cung cấp mã phòng.';
}
