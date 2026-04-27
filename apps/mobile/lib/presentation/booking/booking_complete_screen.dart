import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';
import 'widgets/booking_summary_row.dart';

class BookingCompleteScreen extends StatelessWidget {
  final int fieldId;
  const BookingCompleteScreen({super.key, required this.fieldId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Lottie.asset(
                'assets/animations/login_successful_animation.json',
                width: 200,
                repeat: false,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: AppColors.success, size: 100),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Rezervimi u Krye!',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Rezervimi juaj është regjistruar me sukses. Pronari do t\'ju kontaktojë për konfirmim.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 32),
              
              // Booking Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppShadows.card,
                ),
                child: const Column(
                  children: [
                    BookingSummaryRow('Fusha', 'Arena e Futbollit'),
                    BookingSummaryRow('Data', '25 Tetor 2026'),
                    BookingSummaryRow('Ora', '18:00 - 19:00'),
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
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Kthehu në Faqen Kryesore'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/booking/1'), // Mock ID
                  child: const Text('Shiko Rezervimin'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
