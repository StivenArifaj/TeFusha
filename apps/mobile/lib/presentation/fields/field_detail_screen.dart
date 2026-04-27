import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';
import '../../core/di/injection.dart';
import 'bloc/field_bloc.dart';
import 'bloc/field_event.dart';
import 'bloc/field_state.dart';

class FieldDetailScreen extends StatefulWidget {
  final int fieldId;

  const FieldDetailScreen({super.key, required this.fieldId});

  @override
  State<FieldDetailScreen> createState() => _FieldDetailScreenState();
}

class _FieldDetailScreenState extends State<FieldDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _openGoogleMapsNavigation(double lat, double lng) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      final geo = Uri.parse('geo:$lat,$lng?q=$lat,$lng');
      if (await canLaunchUrl(geo)) await launchUrl(geo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FieldBloc(getIt())..add(LoadFieldDetailEvent(widget.fieldId)),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: BlocBuilder<FieldBloc, FieldState>(
          builder: (context, state) {
            if (state is FieldLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FieldError) {
              return Center(child: Text(state.message));
            }
            if (state is FieldDetailLoaded) {
              final field = state.field;
              return Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      // SLIVER APP BAR
                      SliverAppBar(
                        expandedHeight: 280,
                        pinned: true,
                        backgroundColor: Colors.white,
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                              onPressed: () => context.pop(),
                            ),
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: const Icon(Icons.favorite_border, color: AppColors.textDark),
                                onPressed: () {
                                  // toggle favorite
                                },
                              ),
                            ),
                          ),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [AppColors.heroDark, AppColors.heroMid],
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.sports_soccer, color: Colors.white, size: 80),
                            ),
                          ),
                        ),
                      ),

                      // SLIVER LIST
                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: 100), // Space for bottom bar
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // SECTION 1 — NAME & BASIC INFO
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          field.emri_fushes ?? '',
                                          style: const TextStyle(
                                            fontFamily: 'Outfit',
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryLight,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          field.lloji_fushes ?? '',
                                          style: const TextStyle(
                                            fontFamily: 'Outfit',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 14, color: AppColors.primary),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${field.qyteti}, ${field.vendndodhja}',
                                        style: const TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 13,
                                          color: AppColors.textMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _InfoStatCard(
                                        title: 'Çmimi',
                                        value: '${field.cmimi_orari} L',
                                        subtitle: '/orë',
                                        icon: Icons.payments_outlined,
                                      ),
                                      const _InfoStatCard(
                                        title: 'Kapaciteti',
                                        value: '10-14',
                                        subtitle: 'Lojtarë',
                                        icon: Icons.groups_outlined,
                                      ),
                                      const _InfoStatCard(
                                        title: 'Statusi',
                                        value: 'Hapur',
                                        subtitle: 'Tani',
                                        icon: Icons.check_circle_outline,
                                        valueColor: AppColors.success,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // SECTION 2 — RATING
                            GestureDetector(
                              onTap: () {
                                // Navigate to reviews
                              },
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: AppColors.warning, size: 20),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '4.8',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '(24 komente)',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 12,
                                        color: AppColors.textMedium,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.chevron_right, color: AppColors.textLight),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // SECTION 3 — PAJISJET / FACILITIES
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pajisjet dhe Lehtësirat',
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
                                    children: (field.pajisjet?.split(',') ?? ['Dhomë zhveshje', 'Dush', 'Parkim', 'Ndriçim'])
                                        .map((f) => Chip(
                                              label: Text(f.trim()),
                                              backgroundColor: AppColors.inputFill,
                                              labelStyle: const TextStyle(
                                                fontFamily: 'Outfit',
                                                fontSize: 13,
                                                color: AppColors.textDark,
                                              ),
                                              side: BorderSide.none,
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // SECTION 4 — VENDNDODHJA
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Vendndodhja',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  if (field.lat != null && field.lng != null) ...[
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: AppColors.inputFill,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Center(child: Text('Map Placeholder')), // Replace with real map
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            icon: const Icon(Icons.map_outlined),
                                            label: const Text('Harta e plotë'),
                                            onPressed: () {
                                              // show full-screen FlutterMap
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            icon: const Icon(Icons.directions),
                                            label: const Text('Më jep rrugën'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.sportFootball,
                                            ),
                                            onPressed: () => _openGoogleMapsNavigation(
                                                field.lat!.toDouble(), field.lng!.toDouble()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ] else
                                    Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: AppColors.inputFill,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Vendndodhja nuk disponohet',
                                          style: TextStyle(
                                            fontFamily: 'Outfit',
                                            fontSize: 13,
                                            color: AppColors.textLight,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  
                  // BOTTOM PERSISTENT BUTTON
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: AppShadows.bottomNav,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Çmimi',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  color: AppColors.textLight,
                                ),
                              ),
                              Text(
                                'L ${field.cmimi_orari}/orë',
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => context.push('/book/${field.id}'),
                              child: const Text('Rezervo Tani'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _InfoStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color valueColor;

  const _InfoStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.valueColor = AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.textMedium),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11,
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 10,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
