import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';

class MyTeamsScreen extends StatelessWidget {
  const MyTeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock state - switch to true to see loaded state
    final bool hasTeams = true;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Ekipet e Mia'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => context.push('/teams/new'),
          ),
        ],
      ),
      body: hasTeams 
          ? _buildLoadedState(context)
          : _buildEmptyState(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.groups_outlined, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nuk jeni anëtar i asnjë ekipi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Krijoni një ekip të ri ose prisni ftesë nga kapiteni i ekipit tuaj.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/teams/new'),
                child: const Text('Krijo Ekip'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 3, // Mock count
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        // Mock team data
        final bool isCaptain = index == 0;
        final String sport = index == 1 ? 'Basketboll' : 'Futboll';
        final Color sportColor = index == 1 ? AppColors.sportBasketball : AppColors.sportFootball;
        final IconData sportIcon = index == 1 ? Icons.sports_basketball : Icons.sports_soccer;

        return GestureDetector(
          onTap: () => context.push('/teams/1'), // Mock ID
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: sportColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(sportIcon, color: sportColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FC TeFusha ${index + 1}',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$sport • 5 Anëtarë',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCaptain)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Kapiten',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
