class Validators {
  Validators._();

  // -----------------------
  // Helpers chung
  // -----------------------
  static bool _onlyWhitespace(String? v) =>
      v != null && v.isNotEmpty && v.trim().isEmpty;

  /// Bắt buộc nhập (không cho phép toàn khoảng trắng)
  static String? required(String? value, {String field = "Trường này"}) {
    if (value == null || value.isEmpty || _onlyWhitespace(value)) {
      return "$field không được để trống";
    }
    return null;
  }

  /// Giới hạn độ dài (bao gồm trim)
  static String? lengthInRange(
    String? value,
    int min,
    int max, {
    String field = "Trường này",
  }) {
    if (value == null || value.trim().isEmpty) {
      return "$field không được để trống";
    }
    final len = value.trim().length;
    if (len < min) return "$field phải có ít nhất $min ký tự";
    if (len > max) return "$field không được vượt quá $max ký tự";
    return null;
  }

  // -----------------------
  // Email
  // -----------------------

  /// Chuẩn hoá email: hạ chữ thường + trim
  static String normalizeEmail(String email) => email.trim().toLowerCase();

  /// Email hợp lệ (đủ dùng cho ứng dụng – đơn giản, ổn định)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email không được để trống";
    }
    final email = normalizeEmail(value);
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
    if (!ok) return "Email không hợp lệ";
    return null;
  }

  /// Email *tuỳ chọn* (được bỏ trống, nếu có thì phải hợp lệ)
  static String? validateOptionalEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return validateEmail(value);
  }

  // -----------------------
  // Mật khẩu
  // -----------------------

  /// Kiểm tra mật khẩu tuỳ chọn độ mạnh:
  /// - [min] độ dài tối thiểu
  /// - [requireUpper] phải có A-Z
  /// - [requireLower] phải có a-z
  /// - [requireNumber] phải có 0-9
  /// - [requireSpecial] phải có !@#...
  static String? validatePassword(
    String? value, {
    int min = 8,
    bool requireUpper = true,
    bool requireLower = true,
    bool requireNumber = true,
    bool requireSpecial = true,
  }) {
    if (value == null || value.isEmpty) {
      return "Mật khẩu không được để trống";
    }
    if (value.length < min) {
      return "Mật khẩu phải ít nhất $min ký tự";
    }
    if (requireUpper && !RegExp(r'[A-Z]').hasMatch(value)) {
      return "Mật khẩu phải có ít nhất 1 chữ hoa (A-Z)";
    }
    if (requireLower && !RegExp(r'[a-z]').hasMatch(value)) {
      return "Mật khẩu phải có ít nhất 1 chữ thường (a-z)";
    }
    if (requireNumber && !RegExp(r'\d').hasMatch(value)) {
      return "Mật khẩu phải có ít nhất 1 chữ số (0-9)";
    }
    if (requireSpecial &&
        !RegExp(r'[!@#\$%^&*(),.?":{}|<>\-_/\\~`+=]').hasMatch(value)) {
      return "Mật khẩu phải có ít nhất 1 ký tự đặc biệt";
    }
    return null;
  }

  /// Xác nhận mật khẩu trùng khớp
  static String? matchPassword(String? value, String other) {
    if (value == null || value.isEmpty) return "Vui lòng nhập lại mật khẩu";
    if (value != other) return "Mật khẩu nhập lại không khớp";
    return null;
  }

  // -----------------------
  // Hồ sơ người dùng (Profile)
  // -----------------------

  /// Họ tên: yêu cầu >= 2 ký tự, không toàn khoảng trắng.
  /// Tuỳ chọn: nên có ít nhất 2 từ (bạn bật cờ enforceTwoWords nếu muốn).
  static String? validateFullName(
    String? value, {
    bool enforceTwoWords = false,
  }) {
    if (value == null || value.trim().isEmpty) {
      return "Họ tên không được để trống";
    }
    final name = value.trim();
    if (name.length < 2) return "Họ tên quá ngắn";
    if (enforceTwoWords && name.split(RegExp(r'\s+')).length < 2) {
      return "Vui lòng nhập đầy đủ họ và tên";
    }
    // Ký tự cơ bản cho tên (chấp nhận dấu, khoảng trắng, dấu gạch nối)
    final ok = RegExp(r"^[A-Za-zÀ-ỹĐđ\s\-'.]+$").hasMatch(name);
    if (!ok) return "Họ tên chứa ký tự không hợp lệ";
    return null;
  }

  /// Số điện thoại Việt Nam: cho phép dạng 0xxxxxxxxx hoặc +84xxxxxxxxx (9–10 số sau đầu mạng)
  static String? validateVietnamPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Số điện thoại không được để trống";
    }
    final v = value.trim();
    final vn1 = RegExp(r'^0\d{9}$'); // 0 + 9 số
    final vn2 = RegExp(r'^\+84\d{9,10}$'); // +84 + 9-10 số (tuỳ đầu mạng)
    if (!(vn1.hasMatch(v) || vn2.hasMatch(v))) {
      return "Số điện thoại không hợp lệ (VD: 0912345678 hoặc +84912345678)";
    }
    return null;
  }

  /// Địa chỉ: yêu cầu tối thiểu 6 ký tự
  static String? validateAddress(String? value, {int min = 6}) {
    if (value == null || value.trim().isEmpty) {
      return "Địa chỉ không được để trống";
    }
    if (value.trim().length < min) {
      return "Địa chỉ quá ngắn (tối thiểu $min ký tự)";
    }
    return null;
  }

  /// Ngày sinh: không được tương lai, và >= minAge (mặc định 13 tuổi)
  static String? validateDob(DateTime? dob, {int minAge = 13}) {
    if (dob == null) return "Vui lòng chọn ngày sinh";
    final now = DateTime.now();
    if (dob.isAfter(now)) return "Ngày sinh không hợp lệ";
    final age =
        now.year -
        dob.year -
        ((now.month < dob.month ||
                (now.month == dob.month && now.day < dob.day))
            ? 1
            : 0);
    if (age < minAge) return "Bạn phải từ $minAge tuổi trở lên";
    return null;
  }

  /// Username: 3–20 ký tự, a-z 0-9 _ . (không bắt buộc có khoảng trắng)
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty)
      return "Username không được để trống";
    final v = value.trim();
    if (v.length < 3) return "Username tối thiểu 3 ký tự";
    if (v.length > 20) return "Username tối đa 20 ký tự";
    final ok = RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(v);
    if (!ok) return "Username chỉ gồm chữ, số, dấu chấm và gạch dưới";
    return null;
  }

  /// OTP: đúng độ dài (mặc định 6 số)
  static String? validateOtp(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) return "Vui lòng nhập mã OTP";
    if (!RegExp(r'^\d+$').hasMatch(value)) return "OTP chỉ bao gồm chữ số";
    if (value.length != length) return "OTP phải gồm $length chữ số";
    return null;
  }
}
