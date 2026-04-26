import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import 'bloc/standalone_team_bloc.dart';

class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({super.key});

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  final _formKey = GlobalKey<FormState>();
  final _emriCtrl = TextEditingController();
  final _pershkrimCtrl = TextEditingController();
  String _selectedSport = 'Futboll';

  final _sports = ['Futboll', 'Basketboll', 'Tenis', 'Volejboll', 'Tjeter'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Krijo Ekip")),
      body: BlocListener<StandaloneTeamBloc, StandaloneTeamState>(
        listener: (context, state) {
          if (state is StandaloneTeamSuccess) {
            context.read<StandaloneTeamBloc>().add(LoadMyTeamsEvent());
            context.pop();
          } else if (state is StandaloneTeamError) {
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
                TextFormField(
                  controller: _emriCtrl,
                  decoration: const InputDecoration(labelText: "Emri i ekipit"),
                  validator: (v) => (v == null || v.isEmpty) ? "Ju lutem vendosni emrin" : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedSport,
                  decoration: const InputDecoration(labelText: "Lloji i sportit"),
                  items: _sports.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _selectedSport = v!),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _pershkrimCtrl,
                  decoration: const InputDecoration(labelText: "Përshkrimi (Opsionale)"),
                  maxLines: 3,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Krijo Ekipin"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'emri': _emriCtrl.text,
        'lloji_sportit': _selectedSport.toLowerCase(),
        'pershkrim': _pershkrimCtrl.text,
      };
      context.read<StandaloneTeamBloc>().add(CreateStandaloneTeamEvent(data));
    }
  }
}
