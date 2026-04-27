import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BookingSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const BookingSummaryRow(
    this.label,
    this.value, {
    super.key,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: AppColors.textMedium,
            ),
          ),
          Text(
            value,
            style: valueStyle ??
                const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
          ),
        ],
      ),
    );
  }
}
