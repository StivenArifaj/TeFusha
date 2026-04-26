import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/announcement.dart';
import 'bloc/announcement_bloc.dart';

class AnnouncementFeedPage extends StatefulWidget {
  const AnnouncementFeedPage({super.key});

  @override
  State<AnnouncementFeedPage> createState() => _AnnouncementFeedPageState();
}

class _AnnouncementFeedPageState extends State<AnnouncementFeedPage> {
  String _selectedSport = 'Të gjitha';
  final _sports = ['Të gjitha', 'Futboll', 'Basketboll', 'Tenis', 'Volejboll'];

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  void _loadAnnouncements() {
    context.read<AnnouncementBloc>().add(LoadAnnouncementsEvent(
      sport: _selectedSport == 'Të gjitha' ? null : _selectedSport.toLowerCase(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnnouncementBloc(getIt()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("Komuniteti"),
          centerTitle: false,
        ),
        body: Column(
          children: [
            _buildFilters(),
            Expanded(
              child: BlocBuilder<AnnouncementBloc, AnnouncementState>(
                builder: (context, state) {
                  if (state is AnnouncementLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AnnouncementError) {
                    return Center(child: Text(state.message));
                  } else if (state is AnnouncementsLoaded) {
                    if (state.announcements.isEmpty) {
                      return const Center(child: Text("Nuk ka njoftime për momentin."));
                    }
                    return ListView.builder(
                      itemCount: state.announcements.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) => _AnnouncementCard(announcement: state.announcements[index]),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            onPressed: () => context.push('/community/new'),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Krijo Njoftim", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 60,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _sports.length,
        itemBuilder: (context, index) {
          final sport = _sports[index];
          final isSelected = _selectedSport == sport;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(sport),
              selected: isSelected,
              onSelected: (val) {
                setState(() => _selectedSport = sport);
                _loadAnnouncements();
              },
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    Color typeColor;
    String typeLabel;

    switch (announcement.tipi) {
      case AnnouncementType.kerkoLojtar:
        typeColor = Colors.blue;
        typeLabel = "Kërkojmë Lojtar";
        break;
      case AnnouncementType.kerkoKundershtare:
        typeColor = Colors.pink;
        typeLabel = "Kërkojmë Kundërshtar";
        break;
      case AnnouncementType.kerkoEkip:
        typeColor = Colors.purple;
        typeLabel = "Kërkoj Ekip";
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(announcement.perdoruesi?.emri[0].toUpperCase() ?? "U", 
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(announcement.perdoruesi?.emri ?? "Përdorues", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(timeago.format(announcement.created_at, locale: 'sq'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(typeLabel, style: TextStyle(color: typeColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(announcement.titull, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            Text(announcement.pershkrim, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.people_outline, size: 16, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text("${announcement.lojtare_nevojitet} lojtarë", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push('/community/${announcement.id}'),
                  child: const Text("Përgjigju"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
