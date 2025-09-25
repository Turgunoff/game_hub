import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/tournament.dart';

class TournamentCard extends StatelessWidget {
  final Tournament tournament;
  final VoidCallback onTap;

  const TournamentCard({
    super.key,
    required this.tournament,
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
                _buildTournamentInfo(),
                const SizedBox(height: 12),
                _buildProgressBar(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
                tournament.name,
                style: AppTextStyles.headline4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                tournament.gameType,
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
        tournament.status.name.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: _getStatusColor(),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildTournamentInfo() {
    return Text(
      tournament.description,
      style: AppTextStyles.bodyMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProgressBar() {
    final progress = tournament.currentParticipants / tournament.maxParticipants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Participants',
              style: AppTextStyles.labelMedium,
            ),
            Text(
              '${tournament.currentParticipants}/${tournament.maxParticipants}',
              style: AppTextStyles.labelMedium.copyWith(
                color: _getStatusColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.borderColor,
          valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(
          Icons.attach_money,
          color: AppColors.neonGreen,
          size: 16,
        ),
        Text(
          '\$${tournament.entryFee.toStringAsFixed(0)}',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.neonGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        Icon(
          Icons.emoji_events,
          color: AppColors.accent,
          size: 16,
        ),
        Text(
          '\$${tournament.prizePool.toStringAsFixed(0)}',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.schedule,
          color: AppColors.onSurfaceSecondary,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          _getTimeText(),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurfaceSecondary,
          ),
        ),
      ],
    );
  }

  String _getTimeText() {
    final now = DateTime.now();

    switch (tournament.status) {
      case TournamentStatus.upcoming:
        final diff = tournament.startDate.difference(now);
        if (diff.inDays > 0) {
          return 'Starts in ${diff.inDays}d';
        } else if (diff.inHours > 0) {
          return 'Starts in ${diff.inHours}h';
        } else {
          return 'Starting soon';
        }

      case TournamentStatus.ongoing:
        final diff = tournament.endDate.difference(now);
        if (diff.inHours > 0) {
          return 'Ends in ${diff.inHours}h';
        } else {
          return 'Ending soon';
        }

      case TournamentStatus.completed:
        final diff = now.difference(tournament.endDate);
        if (diff.inDays > 0) {
          return 'Ended ${diff.inDays}d ago';
        } else {
          return 'Recently ended';
        }

      case TournamentStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getStatusColor() {
    switch (tournament.status) {
      case TournamentStatus.upcoming:
        return AppColors.secondary;
      case TournamentStatus.ongoing:
        return AppColors.success;
      case TournamentStatus.completed:
        return AppColors.onSurfaceSecondary;
      case TournamentStatus.cancelled:
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

    return gameGradients[tournament.gameType] ?? AppColors.primaryGradient;
  }

  IconData _getGameIcon() {
    final Map<String, IconData> gameIcons = {
      'PES Mobile 2026': Icons.sports_soccer,
      'PUBG Mobile': Icons.gps_fixed,
      'Free Fire': Icons.local_fire_department,
      'Call of Duty Mobile': Icons.gps_fixed,
    };

    return gameIcons[tournament.gameType] ?? Icons.emoji_events;
  }
}