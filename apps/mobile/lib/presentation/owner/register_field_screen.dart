import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class RegisterFieldScreen extends StatefulWidget {
  const RegisterFieldScreen({super.key});

  @override
  State<RegisterFieldScreen> createState() => _RegisterFieldScreenState();
}

class _RegisterFieldScreenState extends State<RegisterFieldScreen> {
  int _currentStep = 0;

  // Step 1 Controllers
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  String? _selectedSport;
  String? _selectedCity;
  
  final List<String> _sports = ['Futboll', 'Basketboll', 'Tenis', 'Volejboll'];
  final List<String> _cities = ['Tiranë', 'Durrës', 'Vlorë', 'Shkodër', 'Elbasan'];

  // Step 2 State
  final Map<String, bool> _amenities = {
    'Ndriçim artificial': false,
    'Dhomat e zhveshjes': false,
    'Parkim': false,
    'Wi-Fi': false,
    'Fryerje topi': false,
    'Tualete': false,
    'Bar/Restorant': false,
  };
  final _otherAmenitiesCtrl = TextEditingController();

  // Step 3 Controllers
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Regjistro Fushën',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Custom Stepper
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              children: [
                _buildStepIndicator(0),
                Expanded(child: Container(height: 2, color: _currentStep > 0 ? AppColors.primary : AppColors.divider)),
                _buildStepIndicator(1),
                Expanded(child: Container(height: 2, color: _currentStep > 1 ? AppColors.primary : AppColors.divider)),
                _buildStepIndicator(2),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (_currentStep == 0) _buildStep1(),
                  if (_currentStep == 1) _buildStep2(),
                  if (_currentStep == 2) _buildStep3(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Bottom Navigation
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0) ...[
                  OutlinedButton(
                    onPressed: () => setState(() => _currentStep--),
                    child: const Text('Prapa'),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep < 2) {
                        setState(() => _currentStep++);
                      } else {
                        // Submit form
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fusha u regjistrua me sukses!'), backgroundColor: AppColors.success),
                        );
                        context.pop();
                      }
                    },
                    child: Text(_currentStep < 2 ? 'Vazhdo' : 'Regjistro'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex) {
    final isActive = _currentStep == stepIndex;
    final isCompleted = _currentStep > stepIndex;
    
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive || isCompleted ? AppColors.primary : AppColors.inputFill,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
                '${stepIndex + 1}',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : AppColors.textLight,
                ),
              ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informacioni Bazë',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameCtrl,
          decoration: const InputDecoration(labelText: 'Emri i Fushës'),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedSport,
          decoration: const InputDecoration(labelText: 'Lloji i Sportit'),
          items: _sports.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (val) => setState(() => _selectedSport = val),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedCity,
          decoration: const InputDecoration(labelText: 'Qyteti'),
          items: _cities.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (val) => setState(() => _selectedCity = val),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressCtrl,
          decoration: const InputDecoration(labelText: 'Adresa e plotë'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Çmimi për orë (L)'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _capacityCtrl,
                decoration: const InputDecoration(labelText: 'Kapaciteti (lojtarë)'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pajisjet',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Zgjidh pajisjet dhe lehtësirat e disponueshme:',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: AppColors.textMedium,
          ),
        ),
        const SizedBox(height: 16),
        ..._amenities.keys.map((key) {
          return CheckboxListTile(
            title: Text(
              key,
              style: const TextStyle(fontFamily: 'Outfit', fontSize: 14),
            ),
            value: _amenities[key],
            onChanged: (bool? value) {
              setState(() {
                _amenities[key] = value ?? false;
              });
            },
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
        const SizedBox(height: 16),
        TextFormField(
          controller: _otherAmenitiesCtrl,
          decoration: const InputDecoration(labelText: 'Pajisje të tjera (opsional)'),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    final bool hasCoordinates = _latCtrl.text.isNotEmpty && _lngCtrl.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vendndodhja GPS',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hapni Google Maps, mbani shtypur mbi vendndodhjen tuaj dhe kopjoni koordinatat.',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: AppColors.textMedium,
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _latCtrl,
          decoration: const InputDecoration(labelText: 'Gjerësia gjeografike (Lat)'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lngCtrl,
          decoration: const InputDecoration(labelText: 'Gjatësia gjeografike (Lng)'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 24),
        if (hasCoordinates)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('Map Placeholder (FieldMapWidget)')),
          ),
      ],
    );
  }
}
