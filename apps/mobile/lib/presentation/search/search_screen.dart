import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<String> _recentSearches = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _searchController.addListener(() {
      setState(() {
        _isSearching = _searchController.text.isNotEmpty;
      });
    });
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList('recent_searches') ?? [];
    
    searches.remove(query);
    searches.insert(0, query);
    if (searches.length > 10) searches.removeLast();
    
    await prefs.setStringList('recent_searches', searches);
    setState(() => _recentSearches = searches);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Search Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  BackButton(
                    color: AppColors.textDark,
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (val) {
                        _saveRecentSearch(val);
                        // Trigger search bloc here
                      },
                      decoration: InputDecoration(
                        hintText: 'Kërko fusha sportive...',
                        hintStyle: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLight,
                        ),
                        filled: true,
                        fillColor: AppColors.inputFill,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _isSearching
                            ? IconButton(
                                icon: const Icon(Icons.close, color: AppColors.textMedium, size: 20),
                                onPressed: () => _searchController.clear(),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => context.push('/filter'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune, color: AppColors.primary, size: 22),
                    ),
                  ),
                ],
              ),
            ),
            
            // Body
            Expanded(
              child: _isSearching ? _buildSearchResults() : _buildRecentSearches(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) {
      return const Center(
        child: Text(
          'Nuk ka kërkime të fundit.',
          style: TextStyle(color: AppColors.textMedium, fontFamily: 'Outfit'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kërkimet e fundit',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('recent_searches');
                  setState(() => _recentSearches.clear());
                },
                child: const Text('Fshi', style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((search) {
              return ActionChip(
                label: Text(search),
                backgroundColor: AppColors.inputFill,
                labelStyle: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide.none,
                ),
                onPressed: () {
                  _searchController.text = search;
                  // Trigger search block here
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // Placeholder for BlocBuilder showing FieldCard list
    return Center(
      child: Text(
        'Duke kërkuar për "${_searchController.text}"...',
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          color: AppColors.textMedium,
        ),
      ),
    );
  }
}
