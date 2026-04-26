import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/sport_icons.dart';
import '../../../core/di/injection.dart';
import 'bloc/field_bloc.dart';
import 'bloc/field_event.dart';
import 'bloc/field_state.dart';
import 'widgets/field_map_widget.dart';

class FieldDetailPage extends StatelessWidget {
  final int fieldId;
  const FieldDetailPage({super.key, required this.fieldId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FieldBloc(getIt())..add(LoadFieldDetailEvent(fieldId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<FieldBloc, FieldState>(
          builder: (context, state) {
            if (state is FieldLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FieldError) {
              return Center(child: Text(state.message));
            } else if (state is FieldDetailLoaded) {
              final field = state.field;
              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        _buildSliverAppBar(context, field.emri_fushes, field.lloji_fushes.toString()),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            field.emri_fushes,
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 24),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on, size: 16, color: AppColors.textHint),
                                              const SizedBox(width: 4),
                                              Text(field.qyteti, style: const TextStyle(color: AppColors.textSecondary)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "${field.cmimi_orari} L/orë",
                                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text("Pajisjet & Shërbimet", style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 12),
                                _buildFeatures(field.pajisjet ?? ""),
                                const SizedBox(height: 24),
                                Text("Vendndodhja", style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 12),
                                if (field.lat != null && field.lng != null)
                                  FieldMapWidget(lat: field.lat!, lng: field.lng!, fieldName: field.emri_fushes),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildBottomBar(context, field.id),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, String name, String lloji) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: SportIcons.getColor(lloji).withOpacity(0.2),
          ),
          child: Center(
            child: Icon(SportIcons.getIcon(lloji), size: 100, color: SportIcons.getColor(lloji)),
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatures(String pajisjet) {
    final list = pajisjet.split(',').where((s) => s.isNotEmpty).toList();
    if (list.isEmpty) return const Text("Nuk ka të dhëna për pajisjet.");
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: list.map((f) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(f.trim(), style: const TextStyle(fontSize: 13)),
      )).toList(),
    );
  }

  Widget _buildBottomBar(BuildContext context, int id) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () => context.push('/fields/$id/book'),
            child: const Text("Rezervo Tani"),
          ),
        ),
      ),
    );
  }
}
