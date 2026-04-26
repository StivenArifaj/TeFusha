import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/standalone_team.dart';
import '../../../data/repositories/standalone_team_repository.dart';

class TeamDetailPage extends StatefulWidget {
  final int id;
  const TeamDetailPage({super.key, required this.id});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  StandaloneTeam? _team;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await getIt<StandaloneTeamRepository>().getTeamById(widget.id);
      if (mounted) setState(() { _team = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_team == null) return const Scaffold(body: Center(child: Text("Ekipi nuk u gjet")));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(_team!.emri)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  const Text("Anëtarët", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  _buildMembersList(),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.group, color: AppColors.primary, size: 32),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_team!.emri, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text(_team!.lloji_sportit.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ],
        ),
        if (_team!.pershkrim != null && _team!.pershkrim!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(_team!.pershkrim!, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ],
    );
  }

  Widget _buildMembersList() {
    final members = _team!.anetaret ?? [];
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final m = members[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(child: Text(m.perdoruesi?.emri[0] ?? "U")),
          title: Text(m.perdoruesi?.emri ?? "Përdorues"),
          subtitle: Text(m.roli == 'kapiteni' ? 'Kapiten' : 'Anëtar'),
          trailing: m.roli == 'kapiteni' ? const Icon(Icons.star, color: Colors.amber, size: 16) : null,
        );
      },
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {}, // TODO: Invite logic
                icon: const Icon(Icons.person_add_outlined),
                label: const Text("Fto Shokët"),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {}, // TODO: Leave logic
              child: const Text("Largohu nga Ekipi", style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      ),
    );
  }
}
