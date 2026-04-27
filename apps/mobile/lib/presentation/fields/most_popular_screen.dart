import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../home/widgets/sport_category_chip.dart';
import 'bloc/field_bloc.dart';
import 'bloc/field_event.dart';
import 'bloc/field_state.dart';

// Placeholder for full field card until implemented properly
class FieldCard extends StatelessWidget {
  final dynamic field;
  const FieldCard({super.key, required this.field});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/field/${field.id}'),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Center(child: Icon(Icons.stadium, size: 40, color: AppColors.textLight)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field.emri_fushes ?? 'Fusha',
                        style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${field.qyteti ?? ''}',
                        style: const TextStyle(fontFamily: 'Outfit', color: AppColors.textMedium, fontSize: 13),
                      ),
                    ],
                  ),
                  Text(
                    '${field.cmimi_orari} L/orë',
                    style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MostPopularScreen extends StatefulWidget {
  const MostPopularScreen({super.key});

  @override
  State<MostPopularScreen> createState() => _MostPopularScreenState();
}

class _MostPopularScreenState extends State<MostPopularScreen> {
  String _selectedCategory = 'Të gjitha';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FieldBloc>().add(LoadFieldsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Fushat Sportive'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => context.push('/filter'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SportCategoryChip(
                    label: 'Të gjitha',
                    icon: Icons.sports,
                    isSelected: _selectedCategory == 'Të gjitha',
                    onTap: () => setState(() => _selectedCategory = 'Të gjitha'),
                  ),
                  const SizedBox(width: 8),
                  SportCategoryChip(
                    label: 'Futboll',
                    icon: Icons.sports_soccer,
                    isSelected: _selectedCategory == 'Futboll',
                    onTap: () => setState(() => _selectedCategory = 'Futboll'),
                  ),
                  const SizedBox(width: 8),
                  SportCategoryChip(
                    label: 'Basketboll',
                    icon: Icons.sports_basketball,
                    isSelected: _selectedCategory == 'Basketboll',
                    onTap: () => setState(() => _selectedCategory = 'Basketboll'),
                  ),
                  const SizedBox(width: 8),
                  SportCategoryChip(
                    label: 'Tenis',
                    icon: Icons.sports_tennis,
                    isSelected: _selectedCategory == 'Tenis',
                    onTap: () => setState(() => _selectedCategory = 'Tenis'),
                  ),
                  const SizedBox(width: 8),
                  SportCategoryChip(
                    label: 'Volejboll',
                    icon: Icons.sports_volleyball,
                    isSelected: _selectedCategory == 'Volejboll',
                    onTap: () => setState(() => _selectedCategory = 'Volejboll'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<FieldBloc, FieldState>(
              builder: (context, state) {
                if (state is FieldLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FieldLoaded) {
                  if (state.fields.isEmpty) {
                    return const Center(child: Text('Nuk u gjetën fusha.', style: TextStyle(fontFamily: 'Outfit')));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.fields.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return FieldCard(field: state.fields[index]);
                    },
                  );
                } else if (state is FieldError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
