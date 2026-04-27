import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../fields/bloc/field_bloc.dart';
import '../fields/bloc/field_event.dart';
import '../fields/bloc/field_state.dart';
import '../fields/widgets/field_card.dart'; // Reusing or making a horizontal variant
import '../common/widgets/section_header.dart';
import 'widgets/sport_category_chip.dart';

// Placeholder widgets to satisfy the compiler
class AnnouncementCardCompact extends StatelessWidget {
  const AnnouncementCardCompact({super.key});
  @override Widget build(BuildContext context) => Container(height: 80, color: Colors.grey[200], margin: const EdgeInsets.only(bottom: 8));
}
class EventCardCompact extends StatelessWidget {
  const EventCardCompact({super.key});
  @override Widget build(BuildContext context) => Container(height: 80, color: Colors.grey[200], margin: const EdgeInsets.only(bottom: 8));
}
class FieldCardHorizontal extends StatelessWidget {
  final dynamic field;
  const FieldCardHorizontal({super.key, required this.field});
  @override Widget build(BuildContext context) => Container(width: 280, color: Colors.grey[200], child: const Center(child: Text('Field Card')));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Të gjitha';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FieldBloc>().add(LoadFieldsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // SLIVER 1 — HERO HEADER
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.heroDark, AppColors.heroMid],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mirëmëngjes 👋',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          const Text(
                            'Lojtar', // Replace with userName when available
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                            onPressed: () => context.push('/notifications'),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.textLight, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Kërko fusha sportive...',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.push('/filter'),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.tune, color: AppColors.primary, size: 18),
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

          // SLIVER 2 — SPORT CATEGORY CHIPS
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kategoritë',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SportCategoryChip(
                          label: 'Të gjitha',
                          icon: Icons.sports,
                          isSelected: _selectedCategory == 'Të gjitha',
                          onTap: () => setState(() => _selectedCategory = 'Të gjitha'),
                        ),
                        const SizedBox(width: 8),
                        SportCategoryChip(
                          label: 'Futboll',
                          icon: Icons.sports_soccer,
                          isSelected: _selectedCategory == 'Futboll',
                          onTap: () => setState(() => _selectedCategory = 'Futboll'),
                        ),
                        const SizedBox(width: 8),
                        SportCategoryChip(
                          label: 'Basketboll',
                          icon: Icons.sports_basketball,
                          isSelected: _selectedCategory == 'Basketboll',
                          onTap: () => setState(() => _selectedCategory = 'Basketboll'),
                        ),
                        const SizedBox(width: 8),
                        SportCategoryChip(
                          label: 'Tenis',
                          icon: Icons.sports_tennis,
                          isSelected: _selectedCategory == 'Tenis',
                          onTap: () => setState(() => _selectedCategory = 'Tenis'),
                        ),
                        const SizedBox(width: 8),
                        SportCategoryChip(
                          label: 'Volejboll',
                          icon: Icons.sports_volleyball,
                          isSelected: _selectedCategory == 'Volejboll',
                          onTap: () => setState(() => _selectedCategory = 'Volejboll'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SLIVER 3 — FUSHAT AFËR JUSH (Near You)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
              child: Column(
                children: [
                  SectionHeader('Fushat Afër Jush', onSeeAll: () => context.push('/fields')),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: BlocBuilder<FieldBloc, FieldState>(
                      builder: (ctx, state) {
                        if (state is FieldLoading) {
                          return const Center(child: CircularProgressIndicator()); // Placeholder for _horizontalShimmer
                        }
                        if (state is FieldLoaded) {
                          if (state.fields.isEmpty) {
                            return const Center(child: Text('Nuk u gjetën fusha.'));
                          }
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.fields.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 16),
                            itemBuilder: (_, i) => FieldCardHorizontal(field: state.fields[i]),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SLIVER 4 — NJOFTIME AKTIVE (Matchmaking)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
              child: Column(
                children: [
                  SectionHeader('Njoftime Aktive', onSeeAll: () => context.push('/community')),
                  const SizedBox(height: 12),
                  // Showing 2 placeholder widgets directly
                  const AnnouncementCardCompact(),
                  const AnnouncementCardCompact(),
                ],
              ),
            ),
          ),

          // SLIVER 5 — TURNETË E ARDHSHME
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 24),
              child: Column(
                children: [
                  SectionHeader('Turnetë e Ardhshme', onSeeAll: () => context.push('/events')),
                  const SizedBox(height: 12),
                  // Showing 2 placeholder widgets directly
                  const EventCardCompact(),
                  const EventCardCompact(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
