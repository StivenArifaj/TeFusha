import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection.dart';
import 'bloc/field_bloc.dart';
import 'bloc/field_event.dart';
import 'bloc/field_state.dart';
import 'widgets/field_card.dart';

class FieldListPage extends StatefulWidget {
  const FieldListPage({super.key});

  @override
  State<FieldListPage> createState() => _FieldListPageState();
}

class _FieldListPageState extends State<FieldListPage> {
  String _selectedCategory = 'Të gjitha';
  final List<String> _categories = ['Të gjitha', 'Futboll', 'Basketboll', 'Tenis', 'Volejboll'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FieldBloc(getIt())..add(LoadFieldsEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("Gjej Fushën"),
          centerTitle: false,
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
          ],
        ),
        body: Column(
          children: [
            _buildCategorySelector(),
            Expanded(
              child: BlocBuilder<FieldBloc, FieldState>(
                builder: (context, state) {
                  if (state is FieldLoading) {
                    return _buildShimmerLoading();
                  } else if (state is FieldError) {
                    return Center(child: Text(state.message));
                  } else if (state is FieldLoaded) {
                    final fields = _selectedCategory == 'Të gjitha'
                        ? state.fields
                        : state.fields.where((f) => f.lloji_fushes.toString().toLowerCase() == _selectedCategory.toLowerCase()).toList();

                    if (fields.isEmpty) {
                      return const Center(child: Text(AppStrings.noFields));
                    }

                    return ListView.builder(
                      itemCount: fields.length,
                      padding: const EdgeInsets.all(20),
                      itemBuilder: (context, index) => FieldCard(field: fields[index]),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 60,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedCategory = cat),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
