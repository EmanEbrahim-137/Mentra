import '../models/role_model.dart';
import 'auth_manager.dart';

/// Legacy interface adapter delegating directly to [AuthManager] Singleton.
abstract class AuthService {
  Future<bool> signInWithEmailPassword({
    required String email,
    required String password,
    required String roleId,
  });

  Future<void> sendPasswordReset(String email);
}

/// Implementation using [AuthManager.instance].
class AuthServiceImpl implements AuthService {
  final AuthManager _manager = AuthManager.instance;

  @override
  Future<bool> signInWithEmailPassword({
    required String email,
    required String password,
    required String roleId,
  }) async {
    final result = await _manager.signInWithEmailPassword(
      email: email,
      password: password,
      role: RoleModel(
        id: roleId,
        title: roleId[0].toUpperCase() + roleId.substring(1),
        subtitle: '',
        icon: RoleModel.fromJson({'id': roleId}).icon,
      ),
    );
    return result.isSuccess;
  }

  @override
  Future<void> sendPasswordReset(String email) => _manager.sendPasswordReset(email);
}
