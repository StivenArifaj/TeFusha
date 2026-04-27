import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_colors.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              height: 150,
              repeat: false,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 80,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fjalëkalimi u ndryshua!',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tani mund të hyni me fjalëkalimin tuaj të ri.',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                color: AppColors.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text('Vazhdo te Hyrja'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Fjalëkalim i Ri',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Krijo fjalëkalim të ri',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fjalëkalimi i ri duhet të jetë i ndryshëm nga ai i mëparshmi.',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _newPassCtrl,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                labelText: 'Fjalëkalimi i ri',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPassCtrl,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Konfirmo fjalëkalimin',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_newPassCtrl.text != _confirmPassCtrl.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fjalëkalimet nuk përputhen!'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }
                  _showSuccessDialog();
                },
                child: const Text('Ruaj Fjalëkalimin'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
