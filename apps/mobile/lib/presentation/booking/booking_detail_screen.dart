import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';
import 'widgets/field_summary_mini_card.dart';
import 'widgets/booking_summary_row.dart';

class BookingDetailScreen extends StatelessWidget {
  final int id;
  const BookingDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // Mock field data
    final mockField = {
      'emri_fushes': 'Arena e Futbollit',
      'qyteti': 'Tiranë',
      'lloji_fushes': 'Futboll',
      'cmimi_orari': 3000,
    };
    
    // Mock booking state (ne_pritje, konfirmuar, anuluar)
    const String status = 'ne_pritje';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Detajet e Rezervimit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Status Badge top
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: status == 'ne_pritje' 
                    ? AppColors.warning.withOpacity(0.1) 
                    : status == 'konfirmuar'
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status == 'ne_pritje' 
                    ? 'Në Pritje' 
                    : status == 'konfirmuar'
                        ? 'Konfirmuar'
                        : 'Anuluar',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: status == 'ne_pritje' 
                      ? AppColors.warning 
                      : status == 'konfirmuar'
                          ? AppColors.success
                          : AppColors.error,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            FieldSummaryMiniCard(field: mockField),
            const SizedBox(height: 20),
            
            // Main info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.card,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookingSummaryRow('Data', '25 Tetor 2026'),
                  BookingSummaryRow('Ora', '18:00 - 19:00'),
                  BookingSummaryRow('ID Rezervimit', '#BKG-847291', valueStyle: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMedium,
                  )),
                  Divider(height: 24),
                  BookingSummaryRow(
                    'Totali', 
                    'L 3000', 
                    valueStyle: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Timeline status visual
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statusi',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTimelineStep(
                    title: 'Rezervimi u dërgua',
                    subtitle: '24 Tetor, 14:30',
                    isCompleted: true,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Në pritje të konfirmimit',
                    subtitle: 'Nga pronari i fushës',
                    isCompleted: status == 'ne_pritje' || status == 'konfirmuar',
                    isActive: status == 'ne_pritje',
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Konfirmuar',
                    subtitle: 'Gati për lojë!',
                    isCompleted: status == 'konfirmuar',
                    isActive: status == 'konfirmuar',
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons based on status
            if (status == 'ne_pritje')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Show cancel confirmation dialog
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error, width: 1.5),
                  ),
                  child: const Text('Anulo Rezervimin'),
                ),
              ),
              
            if (status == 'konfirmuar')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Rezervimi juaj është konfirmuar!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
              
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    bool isActive = false,
    required bool isLast,
  }) {
    final color = isCompleted ? AppColors.primary : AppColors.divider;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.white : color,
                border: isActive ? Border.all(color: AppColors.primary, width: 4) : null,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: color,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isCompleted ? AppColors.textDark : AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
              if (!isLast) const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
