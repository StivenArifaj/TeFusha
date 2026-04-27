import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';

class OwnerBookingsScreen extends StatefulWidget {
  final int fieldId;

  const OwnerBookingsScreen({super.key, required this.fieldId});

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen> {
  String _selectedFilter = 'Sot';
  final List<String> _filters = ['Sot', 'Kjo Javë', 'Ky Muaj'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Rezervimet e Fushës'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Filter Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Filtro sipas kohës:',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    color: AppColors.textMedium,
                  ),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: _selectedFilter,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  items: _filters.map((filter) {
                    return DropdownMenuItem(
                      value: filter,
                      child: Text(filter),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedFilter = val);
                    }
                  },
                ),
              ],
            ),
          ),

          // List of Bookings
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: 4, // Mock
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _OwnerBookingCard(
                  status: index % 2 == 0 ? 'ne_pritje' : 'konfirmuar',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerBookingCard extends StatelessWidget {
  final String status;

  const _OwnerBookingCard({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.inputFill,
                radius: 24,
                child: const Text(
                  'AT',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Arbër T.',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sot, 18:00 - 19:00',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'L 3000',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'ne_pritje' ? AppColors.warning.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status == 'ne_pritje' ? 'Në Pritje' : 'Konfirmuar',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: status == 'ne_pritje' ? AppColors.warning : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          if (status == 'ne_pritje') ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error, width: 1.5),
                    ),
                    child: const Text('Refuzo'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                    child: const Text('Konfirmo'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
