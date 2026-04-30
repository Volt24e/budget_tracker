class User {
  final String id;
  final String email;
  final String password;
  final bool isAdmin;  // New field for admin status

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'is_admin': isAdmin ? 1 : 0,  // SQLite stores booleans as 0/1
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      isAdmin: map['is_admin'] == 1,
    );
  }
}
