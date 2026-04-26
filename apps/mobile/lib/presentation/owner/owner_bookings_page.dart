import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';

class OwnerBookingsPage extends StatefulWidget {
  final int fieldId;
  const OwnerBookingsPage({super.key, required this.fieldId});

  @override
  State<OwnerBookingsPage> createState() => _OwnerBookingsPageState();
}

class _OwnerBookingsPageState extends State<OwnerBookingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Menaxho Rezervimet")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3, // Placeholder
        itemBuilder: (context, index) => _BookingRequestCard(),
      ),
    );
  }
}

class _BookingRequestCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Filan Fisteku", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Text("Në Pritje", style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text("069 12 34 567", style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.textHint),
                const SizedBox(width: 8),
                const Text("E Hënë, 25 Prill", style: TextStyle(fontSize: 13)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: AppColors.textHint),
                const SizedBox(width: 8),
                const Text("19:00 - 20:00", style: TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {}, // TODO: Cancel logic
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                    child: const Text("Anulo"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {}, // TODO: Confirm logic
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                    child: const Text("Konfirmo"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => launchUrl(Uri.parse("tel:0691234567")),
                icon: const Icon(Icons.phone, size: 18),
                label: const Text("Telefono Klientin"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
