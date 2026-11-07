import 'role_model.dart';

/// Represents an authenticated user in the Mentara platform.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String department;
  final RoleModel role;
  final String? token;
  final DateTime loggedInAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.role,
    this.token,
    DateTime? loggedInAt,
  }) : loggedInAt = loggedInAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'role': role.toJson(),
      'token': token,
      'loggedInAt': loggedInAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      department: json['department'] as String? ?? '',
      role: RoleModel.fromJson(json['role'] as Map<String, dynamic>? ?? {}),
      token: json['token'] as String?,
      loggedInAt: json['loggedInAt'] != null
          ? DateTime.tryParse(json['loggedInAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
