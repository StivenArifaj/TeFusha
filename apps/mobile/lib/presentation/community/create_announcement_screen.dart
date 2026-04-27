import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/injection.dart';
import 'bloc/announcement_bloc.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() => _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  String _selectedType = 'kerko_lojtar';
  String? _selectedSport;
  int _neededPlayers = 1;
  
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  final List<String> _sports = ['Futboll', 'Basketboll', 'Tenis', 'Volejboll', 'Të tjera'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnnouncementBloc(getIt()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Njoftim i Ri'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Çfarë po kërkon?',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              
              // 3. Type Selection Cards
              Row(
                children: [
                  _TypeCard(
                    title: 'Kërko\nLojtar',
                    icon: Icons.person_add_alt,
                    color: AppColors.info,
                    isSelected: _selectedType == 'kerko_lojtar',
                    onTap: () => setState(() => _selectedType = 'kerko_lojtar'),
                  ),
                  const SizedBox(width: 8),
                  _TypeCard(
                    title: 'Kërko\nKundërshtar',
                    icon: Icons.groups_outlined,
                    color: AppColors.error,
                    isSelected: _selectedType == 'kerko_kundershtar',
                    onTap: () => setState(() => _selectedType = 'kerko_kundershtar'),
                  ),
                  const SizedBox(width: 8),
                  _TypeCard(
                    title: 'Kërko\nEkip',
                    icon: Icons.search,
                    color: Colors.purple,
                    isSelected: _selectedType == 'kerko_ekip',
                    onTap: () => setState(() => _selectedType = 'kerko_ekip'),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              // 5. Dropdown Sport
              DropdownButtonFormField<String>(
                value: _selectedSport,
                decoration: const InputDecoration(labelText: 'Lloji i Sportit'),
                items: _sports.map((sport) => DropdownMenuItem(value: sport, child: Text(sport))).toList(),
                onChanged: (val) => setState(() => _selectedSport = val),
              ),
              
              const SizedBox(height: 16),
              // 7. Titulli
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Titulli (p.sh. Na duhet 1 lojtar për sot)'),
              ),
              
              const SizedBox(height: 16),
              // 9. Përshkrimi
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Përshkrimi',
                  alignLabelWithHint: true,
                ),
              ),
              
              const SizedBox(height: 16),
              // 11. Vendndodhja
              TextFormField(
                controller: _locationCtrl,
                decoration: const InputDecoration(
                  labelText: 'Vendndodhja (opsionale)',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              
              const SizedBox(height: 16),
              // 13. Counter Row (if kerko_lojtar)
              if (_selectedType == 'kerko_lojtar') ...[
                Row(
                  children: [
                    const Text(
                      'Lojtarë të nevojshëm:',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 20),
                            onPressed: _neededPlayers > 1 
                                ? () => setState(() => _neededPlayers--) 
                                : null,
                            color: AppColors.textMedium,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          ),
                          Text(
                            '$_neededPlayers',
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 20),
                            onPressed: () => setState(() => _neededPlayers++),
                            color: AppColors.textMedium,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 40),
              // 15. Submit Button
              BlocConsumer<AnnouncementBloc, AnnouncementState>(
                listener: (context, state) {
                  if (state is AnnouncementSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Njoftimi u postua!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    context.pop();
                  } else if (state is AnnouncementError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
                    );
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AnnouncementLoading
                          ? null
                          : () {
                              // Simulate successful posting
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Njoftimi u postua!'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                              context.pop();
                            },
                      child: state is AnnouncementLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Posto Njoftimin'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : AppColors.divider,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? color : AppColors.textMedium, size: 24),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : AppColors.textMedium,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
