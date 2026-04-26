import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class MatchResultPage extends StatefulWidget {
  final int eventId;
  final int matchId;
  const MatchResultPage({super.key, required this.eventId, required this.matchId});

  @override
  State<MatchResultPage> createState() => _MatchResultPageState();
}

class _MatchResultPageState extends State<MatchResultPage> {
  final _scoreACtrl = TextEditingController(text: "0");
  final _scoreBCtrl = TextEditingController(text: "0");
  String _status = 'perfunduar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Vendos Rezultatin")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rezultati i Ndeshjes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text("Ekipi A", style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _scoreACtrl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text("VS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textHint)),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text("Ekipi B", style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _scoreBCtrl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            const Text("Statusi i Ndeshjes", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _status,
              items: const [
                DropdownMenuItem(value: 'ne_pritje', child: Text("Në Pritje")),
                DropdownMenuItem(value: 'perfunduar', child: Text("Përfunduar")),
              ],
              onChanged: (v) => setState(() => _status = v!),
              decoration: const InputDecoration(),
            ),
            const SizedBox(height: 64),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Save result logic
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rezultati u ruajt!")));
                  context.pop();
                },
                child: const Text("Ruaj Rezultatin"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
