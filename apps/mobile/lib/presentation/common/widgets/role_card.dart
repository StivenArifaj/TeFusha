import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class RoleCard extends StatelessWidget {
  final String role;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textLight,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                role,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
