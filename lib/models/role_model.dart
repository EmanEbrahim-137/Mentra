import 'package:flutter/material.dart';

/// Role model representing user roles within the Mentara workspace.
class RoleModel {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const RoleModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  /// Factory constructor to deserialize from JSON or Firebase document
  factory RoleModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? '';
    return RoleModel(
      id: id,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      icon: _iconForRoleId(id),
    );
  }

  /// Serialize to JSON for persistence or remote sync
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
    };
  }

  static IconData _iconForRoleId(String roleId) {
    switch (roleId) {
      case 'technician':
        return Icons.handyman_outlined;
      case 'supervisor':
        return Icons.assignment_outlined;
      case 'facility_manager':
        return Icons.domain_rounded;
      case 'super_admin':
        return Icons.verified_user_outlined;
      case 'employee':
      default:
        return Icons.person_outline_rounded;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
