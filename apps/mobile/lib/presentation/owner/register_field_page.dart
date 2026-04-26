import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';

class RegisterFieldPage extends StatefulWidget {
  const RegisterFieldPage({super.key});

  @override
  State<RegisterFieldPage> createState() => _RegisterFieldPageState();
}

class _RegisterFieldPageState extends State<RegisterFieldPage> {
  int _currentStep = 0;
  
  // Step 1 controllers
  final _emriCtrl = TextEditingController();
  String _selectedSport = 'Futboll';
  String _selectedCity = 'Tiranë';

  // Step 2
  LatLng _selectedLocation = const LatLng(41.3275, 19.8187); // Tirana center

  // Step 3
  final _cmimiCtrl = TextEditingController();
  final _pajisjetCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Regjistro Fushën")),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _submit();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        steps: [
          Step(
            title: const Text("Info"),
            isActive: _currentStep >= 0,
            content: _buildStep1(),
          ),
          Step(
            title: const Text("Harta"),
            isActive: _currentStep >= 1,
            content: _buildStep2(),
          ),
          Step(
            title: const Text("Detaje"),
            isActive: _currentStep >= 2,
            content: _buildStep3(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        TextField(
          controller: _emriCtrl,
          decoration: const InputDecoration(labelText: "Emri i Fushës"),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedCity,
          decoration: const InputDecoration(labelText: "Qyteti"),
          items: ['Tiranë', 'Durrës', 'Vlorë', 'Shkodër', 'Elbasan'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => setState(() => _selectedCity = v!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedSport,
          decoration: const InputDecoration(labelText: "Lloji i Sportit"),
          items: ['Futboll', 'Basketboll', 'Tenis', 'Volejboll'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) => setState(() => _selectedSport = v!),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Prekni në hartë për të vendosur lokacionin:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _selectedLocation,
                initialZoom: 13,
                onTap: (tapPos, latLng) {
                  setState(() => _selectedLocation = latLng);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.tefusha.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on, color: AppColors.primary, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        TextField(
          controller: _cmimiCtrl,
          decoration: const InputDecoration(labelText: "Çmimi për orë (Lek)", prefixText: "L "),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _pajisjetCtrl,
          decoration: const InputDecoration(labelText: "Pajisjet (të ndara me presje)", hintText: "Dritat, Dushe, Parkim"),
          maxLines: 3,
        ),
      ],
    );
  }

  void _submit() {
    // TODO: Register field logic
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fusha u dërgua për rishikim!")));
    Navigator.pop(context);
  }
}
