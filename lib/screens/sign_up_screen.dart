import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../models/role_model.dart';
import '../services/auth_manager.dart';
import '../widgets/app_button.dart';
import '../widgets/background_contour.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/mentara_logo.dart';
import '../widgets/security_badge.dart';
import 'home_dashboard_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final RoleModel role;

  const SignUpScreen({
    super.key,
    required this.role,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF7F1D1D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Future<void> _onSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError(AppStrings.pleaseFillAllFields);
      return;
    }

    if (password != confirmPassword) {
      _showError(AppStrings.passwordsDoNotMatch);
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthManager.instance.signUpWithEmailPassword(
      name: name,
      email: email,
      password: password,
      role: widget.role,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!result.isSuccess) {
      _showError(result.errorMessage ?? 'Registration failed.');
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeDashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background subtle contour arcs
          const BackgroundContour(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),

                  // Top Navigation Bar (Back button + Centered Mentara Logo)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(22),
                          splashColor: AppColors.splash,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surfaceElevated,
                              border: Border.all(
                                color: AppColors.cardBorder,
                                width: 1.0,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),

                      // Centered Mentara Logo
                      const MentaraLogo(),

                      // Balancing spacer
                      const SizedBox(width: 42),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Center Security Glowing Badge
                  const SecurityBadge(
                    icon: Icons.verified_user_outlined,
                    size: 96,
                  ),

                  const SizedBox(height: 18),

                  // Selected Role kicker
                  Text(
                    widget.role.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Headline
                  const Text(
                    AppStrings.createAccountTitle,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  const Text(
                    AppStrings.createAccountSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Full Name Input
                  CustomTextField(
                    label: AppStrings.fullName,
                    hintText: AppStrings.fullNameHint,
                    controller: _nameController,
                    prefixIcon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 16),

                  // Work Email Input
                  CustomTextField(
                    label: AppStrings.workEmail,
                    hintText: AppStrings.workEmailHint,
                    controller: _emailController,
                    prefixIcon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 16),

                  // Password Input
                  CustomTextField(
                    label: AppStrings.password,
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password Input
                  CustomTextField(
                    label: AppStrings.confirmPassword,
                    controller: _confirmPasswordController,
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _onSignUp(),
                  ),

                  const SizedBox(height: 24),

                  // Create Account Button
                  AppButton(
                    label: AppStrings.createAccountButton,
                    variant: AppButtonVariant.light,
                    isLoading: _isLoading,
                    onTap: _onSignUp,
                  ),

                  const SizedBox(height: 18),

                  // Already have an account? Sign in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.alreadyHaveAccount,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(role: widget.role),
                            ),
                          );
                        },
                        child: const Text(
                          AppStrings.signIn,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Security footer
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 6),
                      Text(
                        AppStrings.roleVerifiedSecureAccess,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
