import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/event.dart';
import 'bloc/event_bloc.dart';
import 'bloc/event_event.dart';
import 'bloc/event_state.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EventBloc>().add(LoadEventsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventError) {
              return Center(child: Text(state.message));
            } else if (state is EventsLoaded) {
              if (state.events.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events_outlined, size: 64, color: AppColors.textLight.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      const Text("Nuk ka turne aktivë për momentin.", style: TextStyle(color: AppColors.textMedium)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.events.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) => _EventCard(event: state.events[index]),
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'events_fab',
          onPressed: () => context.push('/events/create'),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),      );
    }
}

class _EventCard extends StatelessWidget {
  final Event event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/events/${event.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Placeholder
            Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.heroDark, AppColors.heroMid],
                ),
              ),
              child: const Center(
                child: Icon(Icons.emoji_events, size: 64, color: Colors.amber),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.emri_eventit,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text("Hapur", style: TextStyle(color: AppColors.secondary, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 8),
                      Text(
                        "${_formatDate(event.data_fillimit)} - ${_formatDate(event.data_mbarimit)}",
                        style: const TextStyle(color: AppColors.textMedium, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.group, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 8),
                      Text(
                        "Maksimum ${event.nr_max_ekipesh} ekipe",
                        style: const TextStyle(color: AppColors.textMedium, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/events/${event.id}'),
                      child: const Text("Shiko Detajet & Tabelën"),
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

  String _formatDate(String date) {
    try {
      final dt = DateTime.parse(date);
      return DateFormat('d MMM', 'sq').format(dt);
    } catch (e) {
      return date;
    }
  }
}
