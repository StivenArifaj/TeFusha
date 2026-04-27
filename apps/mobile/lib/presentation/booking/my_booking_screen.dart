import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          title: const Text('Rezervimet e Mia'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMedium,
            indicatorColor: AppColors.primary,
            labelStyle: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Aktive'),
              Tab(text: 'Historia'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Aktive Tab
            ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: 2,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _BookingListCard(
                status: i == 0 ? 'ne_pritje' : 'konfirmuar',
              ),
            ),
            
            // Historia Tab (Empty state for demonstration)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.history, size: 60, color: AppColors.textLight),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Nuk keni rezervime të kaluara',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingListCard extends StatelessWidget {
  final String status;

  const _BookingListCard({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = status == 'ne_pritje'
        ? AppColors.warning
        : status == 'konfirmuar'
            ? AppColors.success
            : AppColors.error;

    return GestureDetector(
      onTap: () => context.push('/booking/1'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.stadium, color: AppColors.textMedium),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Arena e Futbollit',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '25 Tetor, 18:00 - 19:00',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 13,
                                color: AppColors.textMedium,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                status == 'ne_pritje'
                                    ? 'Në Pritje'
                                    : status == 'konfirmuar'
                                        ? 'Konfirmuar'
                                        : 'Anuluar',
                                        
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (status == 'ne_pritje')
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Anulo',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
