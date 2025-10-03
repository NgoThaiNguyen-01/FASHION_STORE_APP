import 'package:fashion_store_app/data/database/db_helper.dart';
import 'package:fashion_store_app/data/models/user.dart';

class UserRepository {
  UserRepository._();

  /// Đăng nhập: trả về User nếu đúng, null nếu sai
  static Future<User?> login(String email, String password) async {
    final db = await DBHelper.database;
    final res = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  /// Đăng ký khách hàng (role = Customer)
  static Future<User> createCustomer({
    required String name,
    required String email,
    required String password,
    String? address,
    String? phone,
  }) async {
    final db = await DBHelper.database;
    // kiểm tra trùng email
    final exists = await emailExists(email);
    if (exists) {
      throw Exception('Email đã tồn tại');
    }

    final userId = await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
      'role': 'Customer',
    });

    await db.insert('customers', {
      'user_id': userId,
      'address': address,
      'phone': phone,
    });

    return getById(userId);
  }

  /// Kiểm tra email đã tồn tại chưa
  static Future<bool> emailExists(String email) async {
    final db = await DBHelper.database;
    final res = await db.query(
      'users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  /// Đổi mật khẩu theo email
  static Future<void> updatePasswordByEmail(
    String email,
    String newPassword,
  ) async {
    final db = await DBHelper.database;
    final count = await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
    if (count == 0) {
      throw Exception('Không tìm thấy tài khoản với email này');
    }
  }

  /// Lấy user theo id
  static Future<User> getById(int id) async {
    final db = await DBHelper.database;
    final res = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) {
      throw Exception('User không tồn tại');
    }
    return User.fromMap(res.first);
  }

  /// Lấy user theo email
  static Future<User?> getByEmail(String email) async {
    final db = await DBHelper.database;
    final res = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }
}
