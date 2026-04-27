import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AnnouncementCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onTap;

  const AnnouncementCard({
    super.key,
    this.isExpanded = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final type = 'kerko_lojtar'; // kerko_lojtar, kerko_kundershtar, kerko_ekip
    
    Color getTypeColor() {
      switch (type) {
        case 'kerko_lojtar': return AppColors.info;
        case 'kerko_kundershtar': return AppColors.error;
        case 'kerko_ekip': return Colors.purple;
        default: return AppColors.textMedium;
      }
    }

    String getTypeText() {
      switch (type) {
        case 'kerko_lojtar': return 'Kërko Lojtar';
        case 'kerko_kundershtar': return 'Kërko Kundërshtar';
        case 'kerko_ekip': return 'Kërko Ekip';
        default: return 'Njoftim';
      }
    }

    final cardContent = Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryLight,
                child: const Text(
                  'AT',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Arbër T.',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Kapiten',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10,
                    color: AppColors.textMedium,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                '2 orë më parë',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: getTypeColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              getTypeText(),
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: getTypeColor(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Na duhet 1 lojtar për kalçeto sot në darkë',
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            maxLines: isExpanded ? null : 2,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Kemi rezervuar fushën në orën 20:00. Na mungon një lojtar mbrojtës për të plotësuar ekipin. Niveli mesatar.',
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              color: AppColors.textMedium,
            ),
            maxLines: isExpanded ? null : 2,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(icon: Icons.sports_soccer, label: 'Futboll'),
              const SizedBox(width: 8),
              _InfoChip(icon: Icons.location_on_outlined, label: 'Arena Tirana'),
              const Spacer(),
              const Text(
                '3 përgjigje',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: cardContent,
      );
    }
    
    return cardContent;
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textMedium),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}
