import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/announcement.dart';
import '../../../data/repositories/announcement_repository.dart';
import 'bloc/announcement_bloc.dart';

class AnnouncementDetailPage extends StatefulWidget {
  final int id;
  const AnnouncementDetailPage({super.key, required this.id});

  @override
  State<AnnouncementDetailPage> createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
  final _msgCtrl = TextEditingController();
  Announcement? _announcement;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await getIt<AnnouncementRepository>().getAnnouncementById(widget.id);
      if (mounted) setState(() { _announcement = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_announcement == null) return const Scaffold(body: Center(child: Text("Njoftimi nuk u gjet")));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Detajet e Njoftimit")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text("Përgjigjet", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  _buildResponses(),
                ],
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _announcement!.titull,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            CircleAvatar(radius: 16, child: Text(_announcement!.perdoruesi?.emri[0] ?? "U")),
            const SizedBox(width: 8),
            Text(_announcement!.perdoruesi?.emri ?? "Përdorues", style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(timeago.format(_announcement!.created_at, locale: 'sq'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 20),
        Text(_announcement!.pershkrim, style: const TextStyle(fontSize: 16, height: 1.5)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.people_outline, color: AppColors.primary),
              const SizedBox(width: 8),
              Text("Nevojiten ${_announcement!.lojtare_nevojitet} lojtarë", style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponses() {
    final responses = _announcement!.pergjigjet ?? [];
    if (responses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Text("Asnjë përgjigje ende. Bëhu i pari!", style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: responses.length,
      itemBuilder: (context, index) {
        final r = responses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(r.perdoruesi?.emri ?? "Përdorues", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const Spacer(),
                  Text(timeago.format(r.created_at, locale: 'sq'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 4),
              Text(r.mesazhi ?? "", style: const TextStyle(fontSize: 14)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgCtrl,
              decoration: const InputDecoration(
                hintText: "Shkruaj një mesazh...",
                filled: true,
                fillColor: AppColors.background,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendResponse,
            icon: const Icon(Icons.send, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  void _sendResponse() {
    if (_msgCtrl.text.trim().isEmpty) return;
    context.read<AnnouncementBloc>().add(RespondToAnnouncementEvent(_announcement!.id, _msgCtrl.text));
    _msgCtrl.clear();
    _load(); // Reload to see new response
  }
}
