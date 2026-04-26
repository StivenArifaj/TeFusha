import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/event.dart';
import 'bloc/event_bloc.dart';
import 'bloc/event_event.dart';
import 'bloc/event_state.dart';
import 'widgets/bracket_widget.dart';

class EventDetailPage extends StatelessWidget {
  final int eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc(getIt())..add(LoadEventDetailEvent(eventId)),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Detajet e Turneut"),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Informacione"),
                Tab(text: "Tabela"),
                Tab(text: "Ndeshjet"),
              ],
              indicatorColor: Colors.white,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              if (state is EventLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EventError) {
                return Center(child: Text(state.message));
              } else if (state is EventDetailLoaded) {
                final event = state.event;
                return TabBarView(
                  children: [
                    _buildInfoTab(context, event),
                    BracketWidget(matches: event.ndeshjet ?? []),
                    _buildMatchesTab(event.ndeshjet ?? []),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
          bottomNavigationBar: _buildBottomAction(context),
        ),
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context, Event event) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.emri_eventit, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.calendar_today, "Data:", "${_formatDate(event.data_fillimit)} - ${_formatDate(event.data_mbarimit)}"),
          _buildInfoRow(Icons.group, "Kapaciteti:", "${event.nr_max_ekipesh} ekipe"),
          _buildInfoRow(Icons.location_on, "Vendi:", event.fusha?.emri_fushes ?? "Të gjitha fushat"),
          const SizedBox(height: 24),
          const Text("Përshkrimi dhe Rregullat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          Text(
            event.pershkrimi ?? "Nuk ka përshkrim për këtë event.",
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text("$label ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildMatchesTab(List<Match> matches) {
    if (matches.isEmpty) {
      return const Center(child: Text("Nuk ka ndeshje të planifikuara ende."));
    }
    return ListView.builder(
      itemCount: matches.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final m = matches[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: Text(m.ekipi_shtepi?.emri ?? "TBD", textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                    child: Text("${m.gola_shtepi ?? 0} : ${m.gola_udhetimit ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(child: Text(m.ekipi_udhetimit?.emri ?? "TBD", style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))]),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {}, // TODO: Register team logic
            child: const Text("Regjistro Ekipin"),
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final dt = DateTime.parse(date);
      return DateFormat('d MMM yyyy', 'sq').format(dt);
    } catch (e) {
      return date;
    }
  }
}
