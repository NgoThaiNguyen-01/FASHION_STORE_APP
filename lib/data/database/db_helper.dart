import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  DBHelper._();
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fashion_store.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // bảng users
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            role TEXT CHECK(role IN ('Customer','Admin')) NOT NULL
          );
        ''');

        // bảng customers (mở rộng thông tin khách)
        await db.execute('''
          CREATE TABLE customers (
            user_id INTEGER PRIMARY KEY,
            address TEXT,
            phone TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          );
        ''');

        // bảng admins (mở rộng thông tin admin)
        await db.execute('''
          CREATE TABLE admins (
            user_id INTEGER PRIMARY KEY,
            level INTEGER DEFAULT 1,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          );
        ''');

        // seed dữ liệu mẫu
        final userId1 = await db.insert('users', {
          'name': 'Nguyen Van A',
          'email': 'a@gmail.com',
          'password': 'Customer@123',
          // role must match the CHECK constraint values: 'Customer' or 'Admin'
          'role': 'Customer',
        });
        await db.insert('customers', {
          'user_id': userId1,
          'address': '123 Le Loi, HCM',
          'phone': '0901234567',
        });

        final adminId = await db.insert('users', {
          'name': 'Admin',
          'email': 'admin@gmail.com',
          'password': 'Admin@123',
          'role': 'Admin',
        });
        await db.insert('admins', {'user_id': adminId, 'level': 10});
      },
    );
  }
}

// Compatibility shim: some code expects DatabaseHelper.getDatabase()
// Provide a small wrapper forwarding to DBHelper.database
class DatabaseHelper {
  static Future<Database> getDatabase() async => DBHelper.database;
}
