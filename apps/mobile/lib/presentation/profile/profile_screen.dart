import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import 'widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isOwner = true; // Mock role check

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.heroDark, AppColors.heroMid],
                ),
              ),
              padding: const EdgeInsets.only(top: 80, bottom: 40),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryLight,
                    child: const Text(
                      'AT',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Arbër T.',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'arber@example.com',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatBadge(count: '12', label: 'Rezervime'),
                      const SizedBox(width: 16),
                      _StatBadge(count: '2', label: 'Ekipe'),
                      const SizedBox(width: 16),
                      _StatBadge(count: '0', label: 'Evente'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Menu Items
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              transform: Matrix4.translationValues(0.0, -24.0, 0.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  ProfileMenuItem(
                    icon: Icons.history,
                    label: 'Rezervimet e Mia',
                    onTap: () => context.push('/my-bookings'),
                  ),
                  ProfileMenuItem(
                    icon: Icons.favorite_border,
                    label: 'Të preferuarat',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Së shpejti...')),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Njoftimet',
                    onTap: () => context.push('/notifications'),
                  ),
                  ProfileMenuItem(
                    icon: Icons.edit_outlined,
                    label: 'Redakto Profilin',
                    onTap: () => context.push('/profile/edit'),
                  ),
                  if (isOwner)
                    ProfileMenuItem(
                      icon: Icons.dashboard_outlined,
                      label: 'Paneli Im',
                      labelColor: AppColors.primary,
                      onTap: () => context.push('/owner'),
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 24),
                  ),
                  ProfileMenuItem(
                    icon: Icons.lock_outline,
                    label: 'Ndërrimi i Fjalëkalimit',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Së shpejti...')),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    label: 'Ndihmë & Mbështetje',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Së shpejti...')),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Politika e Privatësisë',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Së shpejti...')),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 24),
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    label: 'Dil',
                    isDestructive: true,
                    onTap: () {
                      // Trigger logout
                      context.go('/welcome');
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String count;
  final String label;

  const _StatBadge({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
