class AuthUser {
  final String id;
  final String name;
  final String phone;

  const AuthUser({required this.id, required this.name, required this.phone});

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'].toString(),
        name: json['name'] as String,
        phone: json['phone'] as String,
      );
}
