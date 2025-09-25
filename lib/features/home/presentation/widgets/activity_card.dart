import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getActivityColor().withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getActivityIcon(),
                color: _getActivityColor(),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: AppTextStyles.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTimeAgo(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (activity.gameType != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getGameShortName(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getActivityColor() {
    switch (activity.type) {
      case ActivityType.game:
        final result = activity.metadata?['result'] as String?;
        return result == 'win' ? AppColors.success : AppColors.error;
      case ActivityType.tournament:
        return AppColors.accent;
      case ActivityType.challenge:
        return AppColors.secondary;
      case ActivityType.achievement:
        return AppColors.neonGreen;
      case ActivityType.rating:
        return AppColors.primary;
    }
  }

  IconData _getActivityIcon() {
    switch (activity.type) {
      case ActivityType.game:
        return Icons.sports_esports;
      case ActivityType.tournament:
        return Icons.emoji_events;
      case ActivityType.challenge:
        return Icons.sports_mma;
      case ActivityType.achievement:
        return Icons.military_tech;
      case ActivityType.rating:
        return Icons.trending_up;
    }
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(activity.timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _getGameShortName() {
    if (activity.gameType == null) return '';

    final Map<String, String> gameShorts = {
      'PES Mobile 2026': 'PES',
      'PUBG Mobile': 'PUBG',
      'Free Fire': 'FF',
      'Call of Duty Mobile': 'COD',
      'Mobile Legends': 'ML',
      'Clash Royale': 'CR',
      'Brawl Stars': 'BS',
      'Fortnite Mobile': 'FN',
    };

    return gameShorts[activity.gameType] ?? activity.gameType!.substring(0, 3);
  }
}