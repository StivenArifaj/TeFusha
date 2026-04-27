import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController(text: 'Arbër T.');
  final _phoneCtrl = TextEditingController(text: '+355 69 123 4567');
  final _emailCtrl = TextEditingController(text: 'arber@example.com');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Redakto Profilin',
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
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ndryshimet u ruajtën!'), backgroundColor: AppColors.success),
              );
              context.pop();
            },
            child: const Text(
              'Ruaj',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Profile Photo
            Center(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ngarkimi i fotos së shpejti')),
                  );
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.inputFill,
                      child: const Text(
                        'AT',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Emri i plotë',
                prefixIcon: Icon(Icons.person_outlined),
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Numri i telefonit',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _emailCtrl,
              readOnly: true,
              style: const TextStyle(color: AppColors.textMedium),
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                helperText: 'Email-i nuk mund të ndryshohet.',
              ),
            ),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ndryshimet u ruajtën!'), backgroundColor: AppColors.success),
                  );
                  context.pop();
                },
                child: const Text('Ruaj Ndryshimet'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
