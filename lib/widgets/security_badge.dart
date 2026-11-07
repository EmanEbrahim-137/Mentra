import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SecurityBadge extends StatelessWidget {
  final IconData icon;
  final double size;

  const SecurityBadge({
    super.key,
    this.icon = Icons.verified_user_outlined,
    this.size = 110,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.badgeAuraOuter,
        ),
        alignment: Alignment.center,
        child: Container(
          width: size * 0.74,
          height: size * 0.74,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.badgeAuraMiddle,
          ),
          alignment: Alignment.center,
          child: Container(
            width: size * 0.50,
            height: size * 0.50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceElevated,
              border: Border.all(
                color: AppColors.badgeBorder,
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.primaryGlow,
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: size * 0.25,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
