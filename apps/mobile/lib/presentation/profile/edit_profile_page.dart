import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameCtrl = TextEditingController(text: "Përdorues Test");
  final _phoneCtrl = TextEditingController(text: "0691234567");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Ndrysho Profilin")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.background,
              child: Icon(Icons.camera_alt_outlined, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Emri i plotë", prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: "Nr. telefoni", prefixIcon: Icon(Icons.phone_outlined)),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            const TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: "Email (nuk mund të ndryshohet)",
                prefixIcon: Icon(Icons.email_outlined),
                hintText: "user@example.com",
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Update profile logic
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profili u përditësua!")));
                  Navigator.pop(context);
                },
                child: const Text("Ruaj Ndryshimet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
