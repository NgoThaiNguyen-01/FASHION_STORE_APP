class User {
  final int id;
  final String name;
  final String email;
  final String password; // demo để plain; thực tế nên hash
  final String role; // 'Customer' | 'Admin'

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'] as int,
    name: map['name'] as String,
    email: map['email'] as String,
    password: map['password'] as String,
    role: map['role'] as String,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
    'role': role,
  };
}
