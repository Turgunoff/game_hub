import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class GameSelectionCard extends StatelessWidget {
  final String gameName;
  final bool isSelected;
  final VoidCallback onTap;

  const GameSelectionCard({
    super.key,
    required this.gameName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getGameIcon(),
                  color: isSelected ? Colors.white : AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getShortGameName(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
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

    return gameShorts[gameName] ?? gameName;
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

    return gameIcons[gameName] ?? Icons.sports_esports;
  }
}