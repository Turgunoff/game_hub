import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/rating.dart';

class RatingHistoryTab extends StatelessWidget {
  final String selectedGame;
  final List<Rating> userRatings;

  const RatingHistoryTab({
    super.key,
    required this.selectedGame,
    required this.userRatings,
  });

  @override
  Widget build(BuildContext context) {
    final gameRating = userRatings.firstWhere(
      (rating) => rating.gameType == selectedGame,
      orElse: () => Rating(
        id: 'default',
        userId: 'user_1',
        gameType: selectedGame,
        currentRating: 1000,
        peakRating: 1000,
        gamesPlayed: 0,
        wins: 0,
        losses: 0,
        winRate: 0.0,
        rank: 'Bronze',
        rankProgress: 0,
        lastGameAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildRatingChart(gameRating),
          const SizedBox(height: 24),
          _buildSeasonStats(gameRating),
          const SizedBox(height: 24),
          _buildMatchHistory(),
        ],
      ),
    );
  }

  Widget _buildRatingChart(Rating gameRating) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rating Trend',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rating Chart',
                      style: AppTextStyles.headline4.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Your rating journey over time',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurfaceSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Current', gameRating.currentRating.toString(), AppColors.primary),
                _buildStatItem('Peak', gameRating.peakRating.toString(), AppColors.neonGreen),
                _buildStatItem('Change', '+${(gameRating.currentRating - 1000)}', AppColors.success),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headline4.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSeasonStats(Rating gameRating) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Season Statistics',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSeasonStat(
                    'Best Win Streak',
                    '7 games',
                    Icons.local_fire_department,
                    AppColors.accent,
                  ),
                ),
                Expanded(
                  child: _buildSeasonStat(
                    'Avg. Rating Gain',
                    '+18.5',
                    Icons.trending_up,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSeasonStat(
                    'Most Played',
                    'Weekends',
                    Icons.calendar_today,
                    AppColors.secondary,
                  ),
                ),
                Expanded(
                  child: _buildSeasonStat(
                    'Favorite Time',
                    '8-10 PM',
                    Icons.access_time,
                    AppColors.neonBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonStat(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMatchHistory() {
    // Mock match history data
    final matchHistory = List.generate(15, (index) {
      final isWin = index % 3 != 0; // Random wins/losses
      final ratingChange = isWin ? (15 + (index % 20)) : -(10 + (index % 15));
      final opponent = 'Player${index + 1}${(index * 37) % 999}';

      return {
        'result': isWin ? 'Victory' : 'Defeat',
        'ratingChange': ratingChange,
        'opponent': opponent,
        'date': DateTime.now().subtract(Duration(hours: index * 6)),
        'gameMode': ['Ranked', 'Classic', 'Tournament'][index % 3],
      };
    });

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Match History',
              style: AppTextStyles.headline4,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: matchHistory.length,
            itemBuilder: (context, index) {
              final match = matchHistory[index];
              final isWin = match['result'] == 'Victory';
              final ratingChange = match['ratingChange'] as int;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isWin
                      ? AppColors.success.withValues(alpha: 0.05)
                      : AppColors.error.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isWin ? AppColors.success : AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isWin ? Icons.trending_up : Icons.trending_down,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    match['result'] as String,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isWin ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'vs ${match['opponent']} • ${match['gameMode']} • ${_getTimeAgo(match['date'] as DateTime)}',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${ratingChange > 0 ? '+' : ''}$ratingChange',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isWin ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rating',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}