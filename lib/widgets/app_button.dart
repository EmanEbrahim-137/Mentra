import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum AppButtonVariant {
  primary, // Mint green
  light, // Light / Off-white (Sign in securely)
  disabled, // Dark muted slate green
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final AppButtonVariant variant;
  final IconData trailingIcon;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.trailingIcon = Icons.arrow_forward_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null && !isLoading;

    Color backgroundColor;
    Color contentColor;

    switch (variant) {
      case AppButtonVariant.light:
        backgroundColor = AppColors.buttonLight;
        contentColor = AppColors.buttonLightText;
        break;
      case AppButtonVariant.primary:
        backgroundColor = isEnabled ? AppColors.primary : AppColors.buttonDisabled;
        contentColor = isEnabled ? AppColors.buttonEnabledText : AppColors.buttonDisabledText;
        break;
      case AppButtonVariant.disabled:
        backgroundColor = AppColors.buttonDisabled;
        contentColor = AppColors.buttonDisabledText;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: variant == AppButtonVariant.primary && isEnabled
                ? [
                    const BoxShadow(
                      color: AppColors.primaryGlow,
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              if (isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(contentColor),
                  ),
                )
              else
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: contentColor,
                  ),
                ),
              const Spacer(),
              Icon(
                trailingIcon,
                size: 20,
                color: contentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
