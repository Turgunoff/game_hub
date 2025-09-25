import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/rating.dart';
import 'rating_card.dart';
import 'rank_progress_card.dart';

class GameRatingOverview extends StatelessWidget {
  final String selectedGame;
  final List<Rating> userRatings;

  const GameRatingOverview({
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RankProgressCard(rating: gameRating),
          const SizedBox(height: 16),
          _buildStatsGrid(gameRating),
          const SizedBox(height: 24),
          _buildRecentPerformance(gameRating),
          const SizedBox(height: 24),
          _buildRankDistribution(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(Rating gameRating) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        RatingCard(
          title: 'Current Rating',
          value: gameRating.currentRating.toString(),
          icon: Icons.trending_up,
          color: AppColors.primary,
        ),
        RatingCard(
          title: 'Peak Rating',
          value: gameRating.peakRating.toString(),
          icon: Icons.emoji_events,
          color: AppColors.neonGreen,
        ),
        RatingCard(
          title: 'Games Played',
          value: gameRating.gamesPlayed.toString(),
          icon: Icons.sports_esports,
          color: AppColors.secondary,
        ),
        RatingCard(
          title: 'Win Rate',
          value: '${(gameRating.winRate * 100).toStringAsFixed(1)}%',
          icon: Icons.military_tech,
          color: AppColors.accent,
        ),
      ],
    );
  }

  Widget _buildRecentPerformance(Rating gameRating) {
    // Mock recent performance data
    final recentGames = [
      {'result': 'Win', 'ratingChange': '+25', 'opponent': 'PlayerX'},
      {'result': 'Loss', 'ratingChange': '-18', 'opponent': 'ProGamer'},
      {'result': 'Win', 'ratingChange': '+22', 'opponent': 'Challenger'},
      {'result': 'Win', 'ratingChange': '+28', 'opponent': 'TopPlayer'},
      {'result': 'Loss', 'ratingChange': '-15', 'opponent': 'Master'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Performance',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentGames.length,
              itemBuilder: (context, index) {
                final game = recentGames[index];
                final isWin = game['result'] == 'Win';

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isWin
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isWin ? AppColors.success : AppColors.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          isWin ? Icons.arrow_upward : Icons.arrow_downward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game['result'] as String,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: isWin ? AppColors.success : AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'vs ${game['opponent']}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        game['ratingChange'] as String,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isWin ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankDistribution() {
    // Mock rank distribution data
    final rankData = [
      {'rank': 'Bronze', 'percentage': 35, 'color': const Color(0xFFCD7F32)},
      {'rank': 'Silver', 'percentage': 25, 'color': const Color(0xFFC0C0C0)},
      {'rank': 'Gold', 'percentage': 20, 'color': const Color(0xFFFFD700)},
      {'rank': 'Platinum', 'percentage': 12, 'color': const Color(0xFFE5E4E2)},
      {'rank': 'Diamond', 'percentage': 5, 'color': const Color(0xFFB9F2FF)},
      {'rank': 'Master', 'percentage': 2, 'color': AppColors.neonPink},
      {'rank': 'GM+', 'percentage': 1, 'color': AppColors.neonGreen},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rank Distribution',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            ...rankData.map((data) {
              final percentage = data['percentage'] as int;
              final color = data['color'] as Color;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['rank'] as String,
                          style: AppTextStyles.labelMedium,
                        ),
                        Text(
                          '$percentage%',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: AppColors.borderColor,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}