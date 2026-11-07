import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../models/role_model.dart';
import '../services/role_service.dart';
import '../widgets/background_contour.dart';
import '../widgets/continue_button.dart';
import '../widgets/mentara_logo.dart';
import '../widgets/role_card.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  final RoleService roleService;

  const RoleSelectionScreen({
    super.key,
    RoleService? roleService,
  }) : roleService = roleService ?? const _DefaultRoleServiceFactory();

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _DefaultRoleServiceFactory implements RoleService {
  const _DefaultRoleServiceFactory();

  @override
  Future<List<RoleModel>> getAvailableRoles() => RoleServiceImpl().getAvailableRoles();

  @override
  Future<bool> selectRole(String roleId) => RoleServiceImpl().selectRole(roleId);
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  List<RoleModel> _roles = [];
  String? _selectedRoleId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    final roles = await widget.roleService.getAvailableRoles();
    if (mounted) {
      setState(() {
        _roles = roles;
        _isLoading = false;
      });
    }
  }

  void _onRoleSelected(String roleId) {
    setState(() {
      _selectedRoleId = roleId;
    });
  }

  Future<void> _onContinue() async {
    if (_selectedRoleId == null) return;
    final selectedRole = _roles.firstWhere((r) => r.id == _selectedRoleId);

    await widget.roleService.selectRole(_selectedRoleId!);

    if (!mounted) return;

    // Navigate to Login Screen with the selected role
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoginScreen(role: selectedRole),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = _selectedRoleId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background subtle contour arcs
          const BackgroundContour(),

          SafeArea(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Mentara Brand Logo
                        const MentaraLogo(),

                        const SizedBox(height: 38),

                        // Welcome kicker
                        const Text(
                          AppStrings.welcomeKicker,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.6,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Main headline
                        const Text(
                          AppStrings.mainTitle,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                            letterSpacing: -0.5,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Subtitle
                        const Text(
                          AppStrings.subtitle,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Role Selection Cards
                        ..._roles.map((role) {
                          final active = _selectedRoleId == role.id;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: RoleCard(
                              role: role,
                              isSelected: active,
                              onTap: () => _onRoleSelected(role.id),
                            ),
                          );
                        }),

                        const SizedBox(height: 8),

                        // Continue CTA Button
                        ContinueButton(
                          isEnabled: isSelected,
                          onTap: isSelected ? _onContinue : null,
                        ),

                        const SizedBox(height: 20),

                        // Security notice footer
                        const Center(
                          child: Text(
                            AppStrings.securityNotice,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
