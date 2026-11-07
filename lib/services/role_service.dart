import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import '../models/role_model.dart';

/// Contract for role data retrieval and assignment.
abstract class RoleService {
  Future<List<RoleModel>> getAvailableRoles();
  Future<bool> selectRole(String roleId);
}

/// Implementation of [RoleService] providing Mentara roles.
class RoleServiceImpl implements RoleService {
  static const List<RoleModel> _defaultRoles = [
    RoleModel(
      id: 'employee',
      title: AppStrings.roleEmployeeTitle,
      subtitle: AppStrings.roleEmployeeSubtitle,
      icon: Icons.person_outline_rounded,
    ),
    RoleModel(
      id: 'technician',
      title: AppStrings.roleTechnicianTitle,
      subtitle: AppStrings.roleTechnicianSubtitle,
      icon: Icons.handyman_outlined,
    ),
    RoleModel(
      id: 'supervisor',
      title: AppStrings.roleSupervisorTitle,
      subtitle: AppStrings.roleSupervisorSubtitle,
      icon: Icons.assignment_outlined,
    ),
    RoleModel(
      id: 'facility_manager',
      title: AppStrings.roleFacilityManagerTitle,
      subtitle: AppStrings.roleFacilityManagerSubtitle,
      icon: Icons.domain_rounded,
    ),
    RoleModel(
      id: 'super_admin',
      title: AppStrings.roleSuperAdminTitle,
      subtitle: AppStrings.roleSuperAdminSubtitle,
      icon: Icons.verified_user_outlined,
    ),
  ];

  @override
  Future<List<RoleModel>> getAvailableRoles() async {
    // Simulates fast asynchronous retrieval (e.g. from local cache or Firebase)
    return List.unmodifiable(_defaultRoles);
  }

  @override
  Future<bool> selectRole(String roleId) async {
    // In production, save to SharedPreferences or sync with Firebase Auth
    return true;
  }
}
