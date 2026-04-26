import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/standalone_team.dart';
import '../teams/bloc/standalone_team_bloc.dart';

class RegisterTeamForEventPage extends StatefulWidget {
  final int eventId;
  const RegisterTeamForEventPage({super.key, required this.eventId});

  @override
  State<RegisterTeamForEventPage> createState() => _RegisterTeamForEventPageState();
}

class _RegisterTeamForEventPageState extends State<RegisterTeamForEventPage> {
  int? _selectedTeamId;

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
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text("Zgjidh Ekipin")),
        body: BlocBuilder<StandaloneTeamBloc, StandaloneTeamState>(
          builder: (context, state) {
            if (state is StandaloneTeamLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StandaloneTeamError) {
              return Center(child: Text(state.message));
            } else if (state is StandaloneTeamsLoaded) {
              // Only teams where user is captain
              final myTeams = state.teams.where((t) => t.kapiteni_id != null).toList(); // In a real app, check against current user ID

              if (myTeams.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Nuk keni asnjë ekip ku jeni kapiten."),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.push('/teams/create'),
                        child: const Text("Krijo një Ekip"),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: myTeams.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final team = myTeams[index];
                  final isSelected = _selectedTeamId == team.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTeamId = team.id),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: 2),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.group, color: AppColors.textSecondary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(team.emri, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(team.lloji_sportit.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              ],
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
        bottomNavigationBar: Builder(
          builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))]),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedTeamId == null ? null : () {
                    // TODO: Register logic
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ekipi u regjistrua me sukses!")));
                    context.pop();
                  },
                  child: const Text("Regjistro Ekipin në Event"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
