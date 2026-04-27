import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/injection.dart';
import 'bloc/announcement_bloc.dart';
import 'widgets/announcement_card.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final int id;
  
  const AnnouncementDetailScreen({super.key, required this.id});

  @override
  State<AnnouncementDetailScreen> createState() => _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  final _responseCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnnouncementBloc(getIt())..add(LoadAnnouncementsEvent()), // Assuming it loads detail in a real app
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          title: const Text('Arbër T.'), // Should be dynamic based on the loaded announcement
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Section - Expanded Announcement Card
                    const AnnouncementCard(isExpanded: true),
                    const Divider(height: 1),
                    
                    // Responses Section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Përgjigjet (3)',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Mock responses
                          _ResponseCard(
                            initials: 'EB',
                            name: 'Erald B.',
                            timeAgo: '1 orë më parë',
                            text: 'Përshëndetje! Jam i interesuar. Mund të luaj në mbrojtje pa problem.',
                          ),
                          const SizedBox(height: 16),
                          _ResponseCard(
                            initials: 'KL',
                            name: 'Klaudio L.',
                            timeAgo: '45 min më parë',
                            text: 'Nëse Eraldi nuk mundet, jam i lirë sot në darkë.',
                          ),
                          const SizedBox(height: 16),
                          _ResponseCard(
                            initials: 'AT',
                            name: 'Arbër T.',
                            timeAgo: '10 min më parë',
                            text: 'Erald, të kam shkruar në privat. Shihemi aty!',
                            isPoster: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _responseCtrl,
                        decoration: InputDecoration(
                          hintText: 'Shkruaj një përgjigje...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            color: AppColors.textMedium,
                          ),
                          filled: true,
                          fillColor: AppColors.inputFill,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 20),
                        onPressed: () {
                          if (_responseCtrl.text.isNotEmpty) {
                            // Simulate sending response
                            _responseCtrl.clear();
                            FocusScope.of(context).unfocus();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponseCard extends StatelessWidget {
  final String initials;
  final String name;
  final String timeAgo;
  final String text;
  final bool isPoster;

  const _ResponseCard({
    required this.initials,
    required this.name,
    required this.timeAgo,
    required this.text,
    this.isPoster = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isPoster ? AppColors.primaryLight : AppColors.inputFill,
          child: Text(
            initials,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPoster ? AppColors.primary : AppColors.textMedium,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (isPoster) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Autori',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
