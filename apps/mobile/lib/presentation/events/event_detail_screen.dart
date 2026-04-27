import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';
import '../../core/di/injection.dart';
import 'bloc/event_bloc.dart';
import 'bloc/event_event.dart';
import 'bloc/event_state.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc(getIt())..add(LoadEventDetailEvent(widget.eventId)),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          title: const Text('Detajet e Eventit'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is EventError) {
              return Center(child: Text(state.message));
            }
            if (state is EventDetailLoaded) {
              final event = state.event;
              final isPlanned = event.statusi == 'planifikuar';
              final hasEligibleTeam = true; // Mock

              final startDate = DateTime.tryParse(event.data_fillimit) ?? DateTime.now();
              final endDate = DateTime.tryParse(event.data_mbarimit) ?? DateTime.now();

              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: isPlanned && hasEligibleTeam ? 100 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Info Card
                        Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppShadows.card,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      event.emri_eventit,
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isPlanned ? AppColors.info.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isPlanned ? 'Në Pritje' : 'Aktiv',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isPlanned ? AppColors.info : AppColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _InfoRow(
                                icon: Icons.calendar_today,
                                text: '${DateFormat('dd MMM yyyy').format(startDate)} - ${DateFormat('dd MMM yyyy').format(endDate)}',
                              ),
                              const SizedBox(height: 8),
                              const _InfoRow(
                                icon: Icons.location_on_outlined,
                                text: 'Arena Tirana',
                              ),
                              const SizedBox(height: 8),
                              const _InfoRow(
                                icon: Icons.sports_soccer,
                                text: 'Futboll',
                              ),
                              const SizedBox(height: 8),
                              const _InfoRow(
                                icon: Icons.groups_outlined,
                                text: 'Organizator: Admin',
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Ekipet: ${event.ekipet?.length ?? 0}/${event.nr_max_ekipesh}',
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: LinearProgressIndicator(
                                      value: (event.ekipet?.length ?? 0) / (event.nr_max_ekipesh > 0 ? event.nr_max_ekipesh : 1),
                                      backgroundColor: AppColors.inputFill,
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                      minHeight: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Registered Teams Section
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Ekipet e Regjistruara',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: event.ekipet?.length ?? 0,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final team = event.ekipet![index];
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textMedium,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      team.emri,
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),

                        // Fixtures / Tabela Section
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Tabela / Fixtures',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (event.ndeshjet == null || event.ndeshjet!.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'Ndeshjet nuk janë gjeneruar ende.',
                                  style: TextStyle(fontFamily: 'Outfit', color: AppColors.textMedium),
                                ),
                              ),
                            ),
                          )
                        else
                          DefaultTabController(
                            length: 1, 
                            child: Column(
                              children: [
                                const TabBar(
                                  labelColor: AppColors.primary,
                                  unselectedLabelColor: AppColors.textMedium,
                                  indicatorColor: AppColors.primary,
                                  tabs: [
                                    Tab(text: 'Raundi 1'),
                                  ],
                                ),
                                SizedBox(
                                  height: 300,
                                  child: TabBarView(
                                    children: [
                                      ListView.separated(
                                        padding: const EdgeInsets.all(20),
                                        itemCount: event.ndeshjet!.length,
                                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                                        itemBuilder: (_, i) {
                                          final match = event.ndeshjet![i];
                                          return _MatchCard(match: match);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Bottom Sticky Button
                  if (isPlanned && hasEligibleTeam)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: AppShadows.bottomNav,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/events/${event.id}/register');
                          },
                          child: const Text('Regjistro Ekipin Tim'),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMedium),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _MatchCard extends StatelessWidget {
  final dynamic match;
  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final bool played = match.gola_shtepi != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              match.ekipi_shtepi?.emri ?? 'Ekipi A',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: played ? FontWeight.w700 : FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: played
                ? Text(
                    '${match.gola_shtepi} - ${match.gola_udhetimit}',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  )
                : const Text(
                    'vs',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      color: AppColors.textMedium,
                    ),
                  ),
          ),
          Expanded(
            child: Text(
              match.ekipi_udhetimit?.emri ?? 'Ekipi B',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
