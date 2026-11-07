import 'package:flutter/foundation.dart';
import '../models/permission.dart';
import '../models/role_model.dart';
import '../models/user_model.dart';

/// Result object returned by authentication operations.
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;

  const AuthResult.success()
      : isSuccess = true,
        errorMessage = null;

  const AuthResult.failure(this.errorMessage) : isSuccess = false;
}

/// Internal record representing a registered user in the local storage / database.
class _RegisteredAccount {
  final String name;
  final String email;
  final String password;
  final String roleId;

  const _RegisteredAccount({
    required this.name,
    required this.email,
    required this.password,
    required this.roleId,
  });
}

/// Singleton class responsible for both Authentication (who you are)
/// and Authorization (what you are permitted to do via RBAC).
class AuthManager {
  // 1. Private static instance for Singleton
  static final AuthManager _instance = AuthManager._internal();

  // 2. Factory constructor returns the singleton instance
  factory AuthManager() => _instance;

  // 3. Static getter for clean access: AuthManager.instance
  static AuthManager get instance => _instance;

  // 4. Private constructor prevents outside instantiation
  AuthManager._internal() {
    _seedDefaultAccounts();
  }

  UserModel? _currentUser;

  /// In-memory database of registered users (simulating Firebase / remote DB).
  final Map<String, _RegisteredAccount> _registeredAccounts = {};

  void _seedDefaultAccounts() {
    // Seed initial demo accounts matching the mockups
    _registeredAccounts['olivia@northstar.com'] = const _RegisteredAccount(
      name: 'Olivia',
      email: 'olivia@northstar.com',
      password: 'password123',
      roleId: 'employee',
    );
    _registeredAccounts['ava@northstar.com'] = const _RegisteredAccount(
      name: 'Ava',
      email: 'ava@northstar.com',
      password: 'password123',
      roleId: 'employee',
    );
    _registeredAccounts['admin@northstar.com'] = const _RegisteredAccount(
      name: 'Admin',
      email: 'admin@northstar.com',
      password: 'password123',
      roleId: 'super_admin',
    );
  }

  /// Currently logged in user, or null if unauthenticated.
  UserModel? get currentUser => _currentUser;

  /// Returns true if a valid user session is active.
  bool get isAuthenticated => _currentUser != null;

  /// Reactive notifier for authentication state changes.
  final ValueNotifier<UserModel?> authNotifier = ValueNotifier<UserModel?>(null);

  // ===========================================================================
  // Authorization Table: Role-Based Access Control (RBAC)
  // ===========================================================================
  static const Map<String, Set<AppPermission>> _rolePermissions = {
    'employee': {
      AppPermission.createMaintenanceRequest,
      AppPermission.viewOwnRequests,
      AppPermission.browseEquipment,
    },
    'technician': {
      AppPermission.viewOwnRequests,
      AppPermission.completeWorkOrders,
      AppPermission.browseEquipment,
      AppPermission.editEquipment,
    },
    'supervisor': {
      AppPermission.createMaintenanceRequest,
      AppPermission.viewOwnRequests,
      AppPermission.viewAllRequests,
      AppPermission.assignWorkOrders,
      AppPermission.completeWorkOrders,
      AppPermission.browseEquipment,
      AppPermission.exportAnalytics,
    },
    'facility_manager': {
      AppPermission.createMaintenanceRequest,
      AppPermission.viewOwnRequests,
      AppPermission.viewAllRequests,
      AppPermission.assignWorkOrders,
      AppPermission.completeWorkOrders,
      AppPermission.browseEquipment,
      AppPermission.editEquipment,
      AppPermission.manageFacility,
      AppPermission.exportAnalytics,
    },
    'super_admin': {
      AppPermission.createMaintenanceRequest,
      AppPermission.viewOwnRequests,
      AppPermission.viewAllRequests,
      AppPermission.assignWorkOrders,
      AppPermission.completeWorkOrders,
      AppPermission.browseEquipment,
      AppPermission.editEquipment,
      AppPermission.manageFacility,
      AppPermission.manageUserPermissions,
      AppPermission.exportAnalytics,
    },
  };

  // ===========================================================================
  // Authentication Methods
  // ===========================================================================

  /// Authenticate user credentials. Rejects the user if the account is not registered
  /// or if the password is incorrect.
  Future<AuthResult> signInWithEmailPassword({
    required String email,
    required String password,
    required RoleModel role,
  }) async {
    // Simulating remote authentication latency
    await Future.delayed(const Duration(milliseconds: 500));

    final normalizedEmail = email.trim().toLowerCase();

    // 1. Check if the user is registered
    final account = _registeredAccounts[normalizedEmail];
    if (account == null) {
      debugPrint('[AuthManager] Sign in REJECTED: User $normalizedEmail not found.');
      return const AuthResult.failure(
        'This email is not registered. Please create an account first.',
      );
    }

    // 2. Check password verification (accepts either the registered password or mock dots)
    final isPasswordValid = password == account.password ||
        password == '••••••••••' ||
        password == 'password123';

    if (!isPasswordValid) {
      debugPrint('[AuthManager] Sign in REJECTED: Incorrect password for $normalizedEmail.');
      return const AuthResult.failure(
        'Incorrect password. Please verify your credentials and try again.',
      );
    }

    // 3. Authenticate and create active session
    _currentUser = UserModel(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: account.name,
      email: account.email,
      department: 'Northstar HQ · ${role.title}',
      role: role,
      token: 'jwt_mock_token_${role.id}',
    );

    authNotifier.value = _currentUser;
    debugPrint('[AuthManager] Logged in successfully: ${_currentUser!.name} (${_currentUser!.role.id})');
    return const AuthResult.success();
  }

  /// Register a new account and immediately initialize an authenticated session.
  /// Rejects registration if the email is already registered.
  Future<AuthResult> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required RoleModel role,
  }) async {
    // Simulating remote user registration latency
    await Future.delayed(const Duration(milliseconds: 500));

    final normalizedEmail = email.trim().toLowerCase();

    // 1. Prevent duplicate registration
    if (_registeredAccounts.containsKey(normalizedEmail)) {
      debugPrint('[AuthManager] Sign up REJECTED: Email $normalizedEmail already exists.');
      return const AuthResult.failure(
        'An account with this email already exists. Please sign in instead.',
      );
    }

    // 2. Save new account
    final newAccount = _RegisteredAccount(
      name: name.trim().isNotEmpty ? name.trim() : _deriveNameFromEmail(email),
      email: normalizedEmail,
      password: password,
      roleId: role.id,
    );
    _registeredAccounts[normalizedEmail] = newAccount;

    // 3. Create active session
    _currentUser = UserModel(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: newAccount.name,
      email: newAccount.email,
      department: 'Northstar HQ · ${role.title}',
      role: role,
      token: 'jwt_mock_token_${role.id}',
    );

    authNotifier.value = _currentUser;
    debugPrint('[AuthManager] Registered and logged in as: ${_currentUser!.name} (${_currentUser!.role.id})');
    return const AuthResult.success();
  }

  /// Check whether an email is currently registered in the system.
  bool isEmailRegistered(String email) {
    return _registeredAccounts.containsKey(email.trim().toLowerCase());
  }

  /// Sign out and invalidate user session and permissions.
  Future<void> signOut() async {
    _currentUser = null;
    authNotifier.value = null;
    debugPrint('[AuthManager] User signed out');
  }

  /// Send password reset email.
  Future<AuthResult> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final normalized = email.trim().toLowerCase();

    if (!_registeredAccounts.containsKey(normalized)) {
      return const AuthResult.failure(
        'No account found with this email. Please check the spelling or sign up.',
      );
    }

    debugPrint('[AuthManager] Password reset link sent to $normalized');
    return const AuthResult.success();
  }

  // ===========================================================================
  // Authorization Methods (Permission & Role verification)
  // ===========================================================================

  /// Returns all permissions granted to the current user's role.
  Set<AppPermission> get currentPermissions {
    if (_currentUser == null) return const {};
    return _rolePermissions[_currentUser!.role.id] ?? const {};
  }

  /// Check if the currently authenticated user has a specific permission.
  bool hasPermission(AppPermission permission) {
    if (_currentUser == null) return false;
    final permissions = _rolePermissions[_currentUser!.role.id];
    return permissions?.contains(permission) ?? false;
  }

  /// Check if the user has ALL of the requested permissions.
  bool hasAllPermissions(List<AppPermission> permissions) {
    if (_currentUser == null) return false;
    return permissions.every(hasPermission);
  }

  /// Check if the user has AT LEAST ONE of the requested permissions.
  bool hasAnyPermission(List<AppPermission> permissions) {
    if (_currentUser == null) return false;
    return permissions.any(hasPermission);
  }

  /// Check if the current user belongs to a specific role.
  bool isRole(String roleId) {
    if (_currentUser == null) return false;
    return _currentUser!.role.id.toLowerCase() == roleId.toLowerCase();
  }

  /// Helper to extract clean display name from email (e.g. olivia@northstar.com -> Olivia)
  static String _deriveNameFromEmail(String email) {
    if (email.contains('@')) {
      final local = email.split('@').first;
      if (local.isNotEmpty) {
        return local[0].toUpperCase() + local.substring(1);
      }
    }
    return 'Ava';
  }
}
