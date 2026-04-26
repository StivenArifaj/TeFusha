import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/sport_icons.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/standalone_team.dart';
import 'bloc/standalone_team_bloc.dart';

class MyTeamsPage extends StatefulWidget {
  const MyTeamsPage({super.key});

  @override
  State<MyTeamsPage> createState() => _MyTeamsPageState();
}

class _MyTeamsPageState extends State<MyTeamsPage> {
  @override
  void initState() {
    super.initState();
    context.read<StandaloneTeamBloc>().add(LoadMyTeamsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StandaloneTeamBloc(getIt()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<StandaloneTeamBloc, StandaloneTeamState>(
          builder: (context, state) {
            if (state is StandaloneTeamLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StandaloneTeamError) {
              return Center(child: Text(state.message));
            } else if (state is StandaloneTeamsLoaded) {
              if (state.teams.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group_outlined, size: 64, color: AppColors.textHint.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      const Text("Nuk keni asnjë ekip ende.", style: TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => context.push('/teams/new'),
                        child: const Text("Krijo Ekipin e Parë"),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.teams.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) => _TeamCard(team: state.teams[index]),
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () => context.push('/teams/new'),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final StandaloneTeam team;
  const _TeamCard({required this.team});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: SportIcons.getColor(team.lloji_sportit).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(SportIcons.getIcon(team.lloji_sportit), color: SportIcons.getColor(team.lloji_sportit)),
        ),
        title: Text(team.emri, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${team.memberCount} anëtarë"),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
        onTap: () => context.push('/teams/${team.id}'),
      ),
    );
  }
}
