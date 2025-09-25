import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../features/rating/domain/entities/rating.dart';

class GameRatingCard extends StatelessWidget {
  final Rating rating;

  const GameRatingCard({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                _getRankColor().withValues(alpha: 0.1),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: _getGameGradient(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getGameIcon(),
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getRankColor().withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      rating.rank,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _getRankColor(),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _getShortGameName(),
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                rating.currentRating.toString(),
                style: AppTextStyles.headline4.copyWith(
                  color: _getRankColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: rating.rankProgress / 100,
                backgroundColor: AppColors.borderColor,
                valueColor: AlwaysStoppedAnimation<Color>(_getRankColor()),
                minHeight: 3,
              ),
              const SizedBox(height: 4),
              Text(
                '${rating.wins}W - ${rating.losses}L',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getShortGameName() {
    final Map<String, String> gameShorts = {
      'PES Mobile 2026': 'PES',
      'PUBG Mobile': 'PUBG',
      'Free Fire': 'Free Fire',
      'Call of Duty Mobile': 'COD',
      'Mobile Legends': 'ML',
      'Clash Royale': 'CR',
      'Brawl Stars': 'BS',
      'Fortnite Mobile': 'Fortnite',
    };

    return gameShorts[rating.gameType] ?? rating.gameType;
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

  LinearGradient _getGameGradient() {
    final Map<String, LinearGradient> gameGradients = {
      'PES Mobile 2026': const LinearGradient(
        colors: [AppColors.success, AppColors.neonGreen],
      ),
      'PUBG Mobile': const LinearGradient(
        colors: [AppColors.accent, AppColors.neonOrange],
      ),
      'Free Fire': const LinearGradient(
        colors: [AppColors.error, AppColors.accent],
      ),
      'Call of Duty Mobile': const LinearGradient(
        colors: [AppColors.secondary, AppColors.neonBlue],
      ),
      'Mobile Legends': const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryDark],
      ),
      'Clash Royale': const LinearGradient(
        colors: [AppColors.neonPink, AppColors.accent],
      ),
    };

    return gameGradients[rating.gameType] ?? AppColors.primaryGradient;
  }

  IconData _getGameIcon() {
    final Map<String, IconData> gameIcons = {
      'PES Mobile 2026': Icons.sports_soccer,
      'PUBG Mobile': Icons.gps_fixed,
      'Free Fire': Icons.local_fire_department,
      'Call of Duty Mobile': Icons.gps_fixed,
      'Mobile Legends': Icons.account_tree,
      'Clash Royale': Icons.castle,
      'Brawl Stars': Icons.star,
      'Fortnite Mobile': Icons.construction,
    };

    return gameIcons[rating.gameType] ?? Icons.sports_esports;
  }
}