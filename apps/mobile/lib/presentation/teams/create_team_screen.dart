import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _selectedSport;

  final List<String> _sports = ['Futboll', 'Basketboll', 'Tenis', 'Volejboll'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
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
          'Krijo Ekip të Ri',
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // 1. Team Logo Placeholder (Dotted Border effect mocked with Container)
            Center(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ngarkimi i logos së shpejti')),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                          style: BorderStyle.solid, // Flutter doesn't have dashed borders natively without a package, using solid for now
                        ),
                        color: AppColors.primaryLight,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 40,
                        color: AppColors.primary,
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
            
            // 3. Emri i Ekipit
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Emri i Ekipit',
                prefixIcon: Icon(Icons.groups_outlined),
              ),
            ),
            const SizedBox(height: 16),
            
            // 5. Lloji i Sportit Dropdown
            DropdownButtonFormField<String>(
              value: _selectedSport,
              decoration: const InputDecoration(
                labelText: 'Lloji i Sportit',
                prefixIcon: Icon(Icons.sports_soccer),
              ),
              items: _sports.map((sport) {
                return DropdownMenuItem(
                  value: sport,
                  child: Text(sport, style: const TextStyle(fontFamily: 'Outfit')),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedSport = val);
              },
            ),
            const SizedBox(height: 16),
            
            // 7. Përshkrimi (opsional)
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Përshkrimi (opsional)',
                alignLabelWithHint: true,
              ),
            ),
            
            const SizedBox(height: 40),
            // 9. Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Validate and submit
                  if (_nameCtrl.text.isNotEmpty && _selectedSport != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ekipi u krijua me sukses!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    context.pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ju lutem plotësoni fushat e detyrueshme.'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                child: const Text('Krijo Ekipin'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
