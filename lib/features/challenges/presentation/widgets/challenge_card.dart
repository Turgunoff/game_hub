import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/challenge.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onTap;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                _getStatusColor().withValues(alpha: 0.1),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildChallengeInfo(),
                if (challenge.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 8),
                  _buildDescription(),
                ],
                const SizedBox(height: 12),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: _getGameGradient(),
            borderRadius: BorderRadius.circular(12),
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
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.gameType,
                style: AppTextStyles.headline4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _getChallengeTypeText(),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText().toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: _getStatusColor(),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildChallengeInfo() {
    return Row(
      children: [
        Icon(
          Icons.person_outline,
          size: 16,
          color: AppColors.onSurfaceSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          'vs ${_getOpponentName()}',
          style: AppTextStyles.labelMedium,
        ),
        const Spacer(),
        if (challenge.wager != null && challenge.wager! > 0) ...[
          Icon(
            Icons.attach_money,
            size: 16,
            color: AppColors.neonGreen,
          ),
          Text(
            '\$${challenge.wager!.toStringAsFixed(0)}',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.neonGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        challenge.description!,
        style: AppTextStyles.bodyMedium,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(
          Icons.schedule,
          size: 16,
          color: AppColors.onSurfaceSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          _getTimeText(),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurfaceSecondary,
          ),
        ),
        const Spacer(),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildActionButton() {
    final isMyChallenge = challenge.challengerId == 'auth_user_1';
    final isChallengedUser = challenge.challengedUserId == 'auth_user_1';

    if (challenge.status == ChallengeStatus.pending) {
      if (isMyChallenge) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'WAITING',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        );
      } else if (isChallengedUser || challenge.type == ChallengeType.public) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'ACCEPT',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        );
      }
    } else if (challenge.status == ChallengeStatus.accepted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'PLAY',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      );
    }

    return const SizedBox();
  }

  String _getChallengeTypeText() {
    switch (challenge.type) {
      case ChallengeType.oneVsOne:
        return '1v1 Challenge';
      case ChallengeType.team:
        return 'Team Challenge';
      case ChallengeType.public:
        return 'Open Challenge';
    }
  }

  String _getOpponentName() {
    if (challenge.type == ChallengeType.public) {
      return 'Anyone';
    }

    if (challenge.challengerId == 'auth_user_1') {
      return challenge.challengedUserId == null
          ? 'Anyone'
          : 'Player${challenge.challengedUserId!.split('_').last}';
    } else {
      return 'Player${challenge.challengerId.split('_').last}';
    }
  }

  String _getStatusText() {
    switch (challenge.status) {
      case ChallengeStatus.pending:
        return 'Open';
      case ChallengeStatus.accepted:
        return 'Accepted';
      case ChallengeStatus.ongoing:
        return 'Playing';
      case ChallengeStatus.completed:
        return 'Complete';
      case ChallengeStatus.rejected:
        return 'Rejected';
      case ChallengeStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _getTimeText() {
    final now = DateTime.now();
    final createdAt = challenge.createdAt;
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Color _getStatusColor() {
    switch (challenge.status) {
      case ChallengeStatus.pending:
        return AppColors.warning;
      case ChallengeStatus.accepted:
      case ChallengeStatus.ongoing:
        return AppColors.success;
      case ChallengeStatus.completed:
        return AppColors.primary;
      case ChallengeStatus.rejected:
      case ChallengeStatus.cancelled:
        return AppColors.error;
    }
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
    };

    return gameGradients[challenge.gameType] ?? AppColors.primaryGradient;
  }

  IconData _getGameIcon() {
    final Map<String, IconData> gameIcons = {
      'PES Mobile 2026': Icons.sports_soccer,
      'PUBG Mobile': Icons.gps_fixed,
      'Free Fire': Icons.local_fire_department,
      'Call of Duty Mobile': Icons.gps_fixed,
    };

    return gameIcons[challenge.gameType] ?? Icons.sports_mma;
  }
}