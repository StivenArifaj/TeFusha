import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/injection.dart';
import 'bloc/announcement_bloc.dart';
import 'widgets/announcement_card.dart';

class AnnouncementFeedScreen extends StatefulWidget {
  const AnnouncementFeedScreen({super.key});

  @override
  State<AnnouncementFeedScreen> createState() => _AnnouncementFeedScreenState();
}

class _AnnouncementFeedScreenState extends State<AnnouncementFeedScreen> {
  String _selectedFilter = 'Të gjitha';
  
  final List<String> _filters = [
    'Të gjitha',
    'Kërko Lojtar',
    'Kërko Kundërshtar',
    'Kërko Ekip',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AnnouncementBloc>().add(LoadAnnouncementsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Komuniteti'),
        automaticallyImplyLeading: false, // No back button on main tab
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedFilter = filter);
                          // Add bloc event to filter
                        }
                      },
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.white,
                      backgroundColor: AppColors.inputFill,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      labelStyle: TextStyle(
                        fontFamily: 'Outfit',
                        color: isSelected ? Colors.white : AppColors.textMedium,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Feed List
          Expanded(
            child: BlocBuilder<AnnouncementBloc, AnnouncementState>(
              builder: (context, state) {
                if (state is AnnouncementLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                // Mock showing 5 items regardless of state for UI demonstration
                return ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  itemBuilder: (context, index) {
                    return AnnouncementCard(
                      onTap: () => context.push('/community/1'), // Mock ID
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'community_fab',
        onPressed: () => context.push('/community/new'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),    );
  }
}
