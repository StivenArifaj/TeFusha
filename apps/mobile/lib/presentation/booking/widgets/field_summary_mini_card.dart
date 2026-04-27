import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';

class FieldSummaryMiniCard extends StatelessWidget {
  final dynamic field; // Replace dynamic with Field model later
  
  const FieldSummaryMiniCard({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.stadium, color: AppColors.textMedium),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field?.emri_fushes ?? 'Emri i fushës',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${field?.qyteti ?? 'Qyteti'} • ${field?.lloji_fushes ?? 'Lloji'}',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    color: AppColors.textMedium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${field?.cmimi_orari ?? '0'} L',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                '/orë',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
