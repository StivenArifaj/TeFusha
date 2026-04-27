import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';
import '../common/widgets/section_header.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Paneli Im'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // StatMiniCard Row
            Row(
              children: [
                _StatMiniCard(
                  count: '3',
                  label: 'Fushat',
                  icon: Icons.stadium_outlined,
                ),
                const SizedBox(width: 12),
                _StatMiniCard(
                  count: '12',
                  label: 'Rez. Sot',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(width: 12),
                _StatMiniCard(
                  count: '48',
                  label: 'Rez. Javore',
                  icon: Icons.trending_up,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            SectionHeader(
              'Fushat e Mia', 
              onSeeAll: () {},
            ),
            const SizedBox(height: 12),
            
            // Field List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _OwnerFieldCard(
                  name: 'Arena e Futbollit ${index + 1}',
                  city: 'Tiranë',
                  sport: 'Futboll',
                  bookingsToday: index == 0 ? 5 : 2,
                  isActive: index == 0,
                  onEditTap: () {},
                  onBookingsTap: () => context.push('/owner/bookings'),
                );
              },
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/owner/fields/new'),
                child: const Text('Regjistro Fushë të Re'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;

  const _StatMiniCard({
    required this.count,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textMedium, size: 24),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 12,
                color: AppColors.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _OwnerFieldCard extends StatelessWidget {
  final String name;
  final String city;
  final String sport;
  final int bookingsToday;
  final bool isActive;
  final VoidCallback onEditTap;
  final VoidCallback onBookingsTap;

  const _OwnerFieldCard({
    required this.name,
    required this.city,
    required this.sport,
    required this.bookingsToday,
    required this.isActive,
    required this.onEditTap,
    required this.onBookingsTap,
  });

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
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.stadium, color: AppColors.textMedium),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isActive ? 'Aktiv' : 'Jo Aktiv',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isActive ? AppColors.success : AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$city • $sport',
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$bookingsToday rezervime sot',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  color: AppColors.textMedium,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.textMedium, size: 20),
                    onPressed: onEditTap,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.event_note_outlined, color: AppColors.primary, size: 20),
                    onPressed: onBookingsTap,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
