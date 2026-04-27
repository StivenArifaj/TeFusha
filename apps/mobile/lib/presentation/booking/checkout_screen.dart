import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';
import 'widgets/field_summary_mini_card.dart';
import 'widgets/booking_summary_row.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock field data for checkout
    final mockField = {
      'emri_fushes': 'Arena e Futbollit',
      'qyteti': 'Tiranë',
      'lloji_fushes': 'Futboll',
      'cmimi_orari': 3000,
    };

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Konfirmimi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // 1. FieldSummaryMiniCard
            FieldSummaryMiniCard(field: mockField), // We use dynamic so mock map works temporarily
            
            const SizedBox(height: 20),
            // 3. Detajet e Rezervimit
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
                  Text(
                    'Detajet e Rezervimit',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Divider(height: 24),
                  BookingSummaryRow('Data', '25 Tetor 2026'),
                  BookingSummaryRow('Ora', '18:00 - 19:00'),
                  BookingSummaryRow('Kohëzgjatja', '1 Orë'),
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
            
            const SizedBox(height: 20),
            // 5. Metoda e Pagesës
            const Text(
              'Metoda e Pagesës',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: const Text(
                      'Pagesa kryhet fizikisht në fushë gjatë rezervimit.',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            // 7. Konfirmo button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Simulate success
                  context.go('/booking-complete');
                },
                child: const Text('Konfirmo Rezervimin'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
