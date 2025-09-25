import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/models/game.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.surfaceVariant.withValues(alpha: 0.5),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildGameIcon(),
              _buildGameInfo(),
              const Spacer(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (game.isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'POPULAR',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            const SizedBox(),
          Row(
            children: [
              Icon(
                Icons.star,
                color: AppColors.neonGreen,
                size: 12,
              ),
              const SizedBox(width: 2),
              Text(
                game.rating.toString(),
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameIcon() {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: _getGameGradient(),
          boxShadow: [
            BoxShadow(
              color: _getGameGradient().colors.first.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          _getGameIcon(),
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildGameInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            game.name,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            game.category,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            Icons.people,
            color: AppColors.onSurfaceSecondary,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${(game.playerCount / 1000000).toStringAsFixed(1)}M',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceSecondary,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 12,
          ),
        ],
      ),
    );
  }

  LinearGradient _getGameGradient() {
    final Map<String, LinearGradient> gameGradients = {
      'Sports': const LinearGradient(
        colors: [AppColors.success, AppColors.neonGreen],
      ),
      'Battle Royale': const LinearGradient(
        colors: [AppColors.accent, AppColors.neonOrange],
      ),
      'Shooter': const LinearGradient(
        colors: [AppColors.error, AppColors.accent],
      ),
      'MOBA': const LinearGradient(
        colors: [AppColors.secondary, AppColors.neonBlue],
      ),
      'Strategy': const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryDark],
      ),
      'Action': const LinearGradient(
        colors: [AppColors.neonPink, AppColors.accent],
      ),
    };

    return gameGradients[game.category] ?? AppColors.primaryGradient;
  }

  IconData _getGameIcon() {
    final Map<String, IconData> gameIcons = {
      'Sports': Icons.sports_soccer,
      'Battle Royale': Icons.gps_fixed,
      'Shooter': Icons.gps_fixed,
      'MOBA': Icons.account_tree,
      'Strategy': Icons.psychology,
      'Action': Icons.flash_on,
    };

    return gameIcons[game.category] ?? Icons.sports_esports;
  }
}