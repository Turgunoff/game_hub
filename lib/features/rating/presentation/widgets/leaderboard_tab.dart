import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class LeaderboardTab extends StatelessWidget {
  final String selectedGame;
  final List<Map<String, dynamic>> topPlayers;

  const LeaderboardTab({
    super.key,
    required this.selectedGame,
    required this.topPlayers,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTopThree(),
          const SizedBox(height: 24),
          _buildLeaderboardList(),
        ],
      ),
    );
  }

  Widget _buildTopThree() {
    if (topPlayers.length < 3) {
      return const SizedBox();
    }

    final first = topPlayers[0];
    final second = topPlayers[1];
    final third = topPlayers[2];

    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppColors.neonGreen.withValues(alpha: 0.1),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Top 3 Players',
              style: AppTextStyles.headline4.copyWith(
                color: AppColors.neonGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildPodiumPlayer(second, 2, 80),
                _buildPodiumPlayer(first, 1, 100),
                _buildPodiumPlayer(third, 3, 70),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumPlayer(Map<String, dynamic> player, int rank, double height) {
    final colors = [
      AppColors.neonGreen, // 1st
      const Color(0xFFC0C0C0), // 2nd
      const Color(0xFFCD7F32), // 3rd
    ];

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors[rank - 1], colors[rank - 1].withValues(alpha: 0.7)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colors[rank - 1].withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              player['username'].toString().substring(0, 1).toUpperCase(),
              style: AppTextStyles.headline4.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          player['username'],
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${player['rating']}',
          style: AppTextStyles.bodySmall.copyWith(
            color: colors[rank - 1],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors[rank - 1], colors[rank - 1].withValues(alpha: 0.7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              rank.toString(),
              style: AppTextStyles.headline4.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Global Leaderboard',
              style: AppTextStyles.headline4,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: topPlayers.length,
            itemBuilder: (context, index) {
              final player = topPlayers[index];
              final rank = player['rank'] as int;
              final isCurrentUser = player['is_current_user'] as bool;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getRankColor(rank),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        rank.toString(),
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        player['username'],
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                          color: isCurrentUser ? AppColors.primary : null,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'YOU',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    '${player['rank_name']} • ${player['games_played']} games • ${player['win_rate']}% WR',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${player['rating']}',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: _getRankColor(rank),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (rank > 1) ...[
                        Text(
                          '${player['rating'] - topPlayers[rank - 2]['rating']} behind',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurfaceSecondary,
                          ),
                        ),
                      ],
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

  Color _getRankColor(int rank) {
    if (rank <= 3) {
      return [AppColors.neonGreen, const Color(0xFFC0C0C0), const Color(0xFFCD7F32)][rank - 1];
    } else if (rank <= 10) {
      return AppColors.primary;
    } else if (rank <= 50) {
      return AppColors.secondary;
    } else {
      return AppColors.onSurfaceSecondary;
    }
  }
}