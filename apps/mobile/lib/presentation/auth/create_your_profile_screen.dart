import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class CreateYourProfileScreen extends StatefulWidget {
  const CreateYourProfileScreen({super.key});

  @override
  State<CreateYourProfileScreen> createState() => _CreateYourProfileScreenState();
}

class _CreateYourProfileScreenState extends State<CreateYourProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final List<String> _selectedSports = [];

  final List<String> _sports = [
    'Futboll',
    'Basketboll',
    'Tenis',
    'Volejboll',
    'Të tjera',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profili Juaj',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.inputFill,
                    child: Icon(Icons.person, size: 48, color: AppColors.textLight),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Funksion i ardhshëm')),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            const Text(
              'Sportet tuaja të preferuara:',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sports.map((sport) {
                final isSelected = _selectedSports.contains(sport);
                return FilterChip(
                  label: Text(sport),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSports.add(sport);
                      } else {
                        _selectedSports.remove(sport);
                      }
                    });
                  },
                  selectedColor: AppColors.primary,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textMedium,
                    fontFamily: 'Outfit',
                  ),
                  backgroundColor: AppColors.inputFill,
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                child: const Text('Vazhdoni'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
