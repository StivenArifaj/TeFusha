import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<String> _sports = ['Futboll', 'Basketboll', 'Tenis', 'Volejboll'];
  final List<String> _cities = ['Tiranë', 'Durrës', 'Vlorë', 'Shkodër', 'Elbasan', 'Korçë', 'Fier', 'Berat', 'Lushnjë'];
  
  final List<String> _selectedSports = [];
  String? _selectedCity;
  RangeValues _priceRange = const RangeValues(0, 5000);
  DateTime? _selectedDate;

  void _resetFilters() {
    setState(() {
      _selectedSports.clear();
      _selectedCity = null;
      _priceRange = const RangeValues(0, 5000);
      _selectedDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Filtro Fushat',
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
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text(
              'Pastro',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textMedium,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Sport Type
            const Text(
              'Lloji i Sportit',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
                    fontFamily: 'Outfit',
                    color: isSelected ? Colors.white : AppColors.textMedium,
                  ),
                  backgroundColor: AppColors.inputFill,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 16),

            // 2. City
            const Text(
              'Qyteti',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.inputFill,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: const Text('Zgjidh qytetin', style: TextStyle(color: AppColors.textMedium, fontFamily: 'Outfit')),
              items: _cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city, style: const TextStyle(fontFamily: 'Outfit')),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedCity = val);
              },
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 16),

            // 3. Price
            const Text(
              'Çmimi (L/orë)',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'L ${_priceRange.start.round()}',
                  style: const TextStyle(fontFamily: 'Outfit', color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
                Text(
                  'L ${_priceRange.end.round()}',
                  style: const TextStyle(fontFamily: 'Outfit', color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 5000,
              divisions: 10,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.divider,
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 16),

            // 4. Availability (Date)
            const Text(
              'Disponueshmëria',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.textMedium, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDate == null 
                          ? 'Zgjidh datën' 
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: _selectedDate == null ? AppColors.textMedium : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Apply filters
                  context.pop();
                },
                child: const Text('Apliko Filtrat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
