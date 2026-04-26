import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/announcement.dart';
import 'bloc/announcement_bloc.dart';

class CreateAnnouncementPage extends StatefulWidget {
  const CreateAnnouncementPage({super.key});

  @override
  State<CreateAnnouncementPage> createState() => _CreateAnnouncementPageState();
}

class _CreateAnnouncementPageState extends State<CreateAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final _titullCtrl = TextEditingController();
  final _pershkrimCtrl = TextEditingController();
  final _vendndodhjaCtrl = TextEditingController();
  
  AnnouncementType _selectedType = AnnouncementType.kerkoLojtar;
  String _selectedSport = 'Futboll';
  int _lojtareCount = 1;

  final _sports = ['Futboll', 'Basketboll', 'Tenis', 'Volejboll', 'Tjeter'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Krijo Njoftim"),
        elevation: 0,
      ),
      body: BlocListener<AnnouncementBloc, AnnouncementState>(
        listener: (context, state) {
          if (state is AnnouncementSuccess) {
            context.read<AnnouncementBloc>().add(LoadAnnouncementsEvent());
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Njoftimi u publikua!")),
            );
          } else if (state is AnnouncementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Çfarë po kërkoni?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                _buildTypeSelector(),
                const SizedBox(height: 32),
                
                TextFormField(
                  controller: _titullCtrl,
                  decoration: const InputDecoration(labelText: "Titulli i njoftimit"),
                  validator: (v) => (v == null || v.length < 5) ? "Titulli shumë i shkurtër" : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _pershkrimCtrl,
                  decoration: const InputDecoration(
                    labelText: "Përshkrimi",
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  validator: (v) => (v == null || v.length < 10) ? "Përshkrimi shumë i shkurtër" : null,
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: _selectedSport,
                  decoration: const InputDecoration(labelText: "Lloji i Sportit"),
                  items: _sports.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _selectedSport = v!),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _vendndodhjaCtrl,
                  decoration: const InputDecoration(
                    labelText: "Vendndodhja (Opsionale)",
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildPlayerCounter(),
                
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Publiko Njoftimin"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        _buildTypeChip(AnnouncementType.kerkoLojtar, "Lojtar", Icons.person_add),
        const SizedBox(width: 8),
        _buildTypeChip(AnnouncementType.kerkoKundershtare, "Kundërshtar", Icons.sports_kabaddi),
        const SizedBox(width: 8),
        _buildTypeChip(AnnouncementType.kerkoEkip, "Ekip", Icons.group_add),
      ],
    );
  }

  Widget _buildTypeChip(AnnouncementType type, String label, IconData icon) {
    bool isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Sa lojtarë nevojiten?", style: TextStyle(fontWeight: FontWeight.w600)),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _lojtareCount > 1 ? () => setState(() => _lojtareCount--) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("$_lojtareCount", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _lojtareCount < 22 ? () => setState(() => _lojtareCount++) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'titull': _titullCtrl.text,
        'pershkrim': _pershkrimCtrl.text,
        'lloji_sportit': _selectedSport.toLowerCase(),
        'vendndodhja': _vendndodhjaCtrl.text,
        'lojtare_nevojitet': _lojtareCount,
        'tipi': _getRawType(_selectedType),
      };
      context.read<AnnouncementBloc>().add(CreateAnnouncementEvent(data));
    }
  }

  String _getRawType(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.kerkoLojtar: return 'kerko_lojtar';
      case AnnouncementType.kerkoKundershtare: return 'kerko_kundershtare';
      case AnnouncementType.kerkoEkip: return 'kerko_ekip';
    }
  }
}
