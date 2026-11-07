import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class ContinueButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onTap;
  final String label;

  const ContinueButton({
    super.key,
    required this.isEnabled,
    required this.onTap,
    this.label = AppStrings.continueButton,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isEnabled ? AppColors.primary : AppColors.buttonDisabled,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isEnabled
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
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: isEnabled
                      ? AppColors.buttonEnabledText
                      : AppColors.buttonDisabledText,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: isEnabled
                    ? AppColors.buttonEnabledText
                    : AppColors.buttonDisabledText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
