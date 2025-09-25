import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/rating.dart';

class RankProgressCard extends StatelessWidget {
  final Rating rating;

  const RankProgressCard({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              _getRankColor().withValues(alpha: 0.2),
              _getRankColor().withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_getRankColor(), _getRankColor().withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _getRankColor().withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getRankIcon(),
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rating.rank,
                        style: AppTextStyles.headline3.copyWith(
                          color: _getRankColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${rating.currentRating} Rating',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurfaceSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${rating.wins}W - ${rating.losses}L',
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(rating.winRate * 100).toStringAsFixed(1)}% WR',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress to ${_getNextRank()}',
                      style: AppTextStyles.labelMedium,
                    ),
                    Text(
                      '${rating.rankProgress}%',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: _getRankColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: rating.rankProgress / 100,
                  backgroundColor: AppColors.borderColor,
                  valueColor: AlwaysStoppedAnimation<Color>(_getRankColor()),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text(
                  'Play more games to improve your rank!',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor() {
    final Map<String, Color> rankColors = {
      'Bronze': const Color(0xFFCD7F32),
      'Silver': const Color(0xFFC0C0C0),
      'Gold': const Color(0xFFFFD700),
      'Platinum': const Color(0xFFE5E4E2),
      'Diamond': const Color(0xFFB9F2FF),
      'Master': AppColors.neonPink,
      'Grandmaster': AppColors.neonGreen,
      'Champion': AppColors.accent,
    };

    return rankColors[rating.rank] ?? AppColors.primary;
  }

  IconData _getRankIcon() {
    final Map<String, IconData> rankIcons = {
      'Bronze': Icons.looks_3,
      'Silver': Icons.looks_two,
      'Gold': Icons.looks_one,
      'Platinum': Icons.diamond,
      'Diamond': Icons.auto_awesome,
      'Master': Icons.star,
      'Grandmaster': Icons.emoji_events,
      'Champion': Icons.military_tech,
    };

    return rankIcons[rating.rank] ?? Icons.grade;
  }

  String _getNextRank() {
    final ranks = ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Master', 'Grandmaster', 'Champion'];
    final currentIndex = ranks.indexOf(rating.rank);

    if (currentIndex >= 0 && currentIndex < ranks.length - 1) {
      return ranks[currentIndex + 1];
    }

    return 'Max Rank';
  }
}