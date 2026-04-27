import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final bool isDestructive;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = isDestructive ? AppColors.error : AppColors.primary;
    final finalIconColor = iconColor ?? defaultColor;
    final finalLabelColor = labelColor ?? (isDestructive ? AppColors.error : AppColors.textDark);
    final bgContainerColor = isDestructive ? AppColors.error.withOpacity(0.1) : AppColors.primaryLight;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgContainerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: finalIconColor, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: finalLabelColor,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
      onTap: onTap,
    );
  }
}
