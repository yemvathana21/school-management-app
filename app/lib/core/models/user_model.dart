class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? nis;
  final String? nip;
  final String? phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.nis,
    this.nip,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      nis: json['nis'] as String?,
      nip: json['nip'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'nis': nis,
        'nip': nip,
        'phone': phone,
      };

  bool get isStudent => role == 'student';
  bool get isTeacher => role == 'teacher';
  bool get isAdmin => role == 'admin';
}
