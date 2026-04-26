import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_colors.dart';

class BookingConfirmationPage extends StatelessWidget {
  final int fieldId;
  const BookingConfirmationPage({super.key, required this.fieldId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Lottie Animation
              SizedBox(
                height: 200,
                child: Lottie.network(
                  'https://assets10.lottiefiles.com/packages/lf20_afwjhifi.json',
                  repeat: false,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.check_circle, size: 100, color: AppColors.secondary),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Rezervimi u krye me sukses!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Mund të shihni detajet e rezervimit tuaj në seksionin 'Rezervimet e Mia'.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => context.go('/my-bookings'),
                  child: const Text("Shko te Rezervimet e Mia"),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text("Kthehu në Fillim"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
