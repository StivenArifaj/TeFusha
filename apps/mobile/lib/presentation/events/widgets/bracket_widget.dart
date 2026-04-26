import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/event.dart';

class BracketWidget extends StatelessWidget {
  final List<Match> matches;
  const BracketWidget({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    // Group matches by round
    final groupedMatches = <int, List<Match>>{};
    for (var m in matches) {
      groupedMatches.putIfAbsent(m.raundi, () => []).add(m);
    }
    
    final sortedRounds = groupedMatches.keys.toList()..sort();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sortedRounds.map((round) {
          return Padding(
            padding: const EdgeInsets.only(right: 48),
            child: Column(
              children: [
                Text(
                  "Raundi $round",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                ...groupedMatches[round]!.map((match) => _MatchBox(match: match)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MatchBox extends StatelessWidget {
  final Match match;
  const _MatchBox({required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _buildTeamRow(match.ekipi_shtepi?.emri ?? "TBD", match.gola_shtepi, isWinner: (match.gola_shtepi ?? 0) > (match.gola_udhetimit ?? 0)),
          const Divider(height: 1),
          _buildTeamRow(match.ekipi_udhetimit?.emri ?? "TBD", match.gola_udhetimit, isWinner: (match.gola_udhetimit ?? 0) > (match.gola_shtepi ?? 0)),
        ],
      ),
    );
  }

  Widget _buildTeamRow(String name, int? score, {required bool isWinner}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
                color: isWinner ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            score?.toString() ?? "-",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isWinner ? AppColors.primary : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
