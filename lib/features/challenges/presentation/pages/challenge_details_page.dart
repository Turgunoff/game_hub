import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/challenge.dart';

class ChallengeDetailsPage extends StatefulWidget {
  final Challenge challenge;

  const ChallengeDetailsPage({super.key, required this.challenge});

  @override
  State<ChallengeDetailsPage> createState() => _ChallengeDetailsPageState();
}

class _ChallengeDetailsPageState extends State<ChallengeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Challenge Details',
          style: AppTextStyles.headline3,
        ),
        backgroundColor: AppColors.surface,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChallengeHeader(),
            const SizedBox(height: 24),
            _buildChallengeInfo(),
            if (widget.challenge.description?.isNotEmpty ?? false) ...[
              const SizedBox(height: 24),
              _buildDescription(),
            ],
            if (widget.challenge.gameSettings?.isNotEmpty ?? false) ...[
              const SizedBox(height: 24),
              _buildGameSettings(),
            ],
            const SizedBox(height: 24),
            _buildTimeline(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildChallengeHeader() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              _getStatusColor().withValues(alpha: 0.1),
              Colors.transparent,
            ],
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
                    gradient: _getGameGradient(),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _getGameGradient().colors.first.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getGameIcon(),
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
                        widget.challenge.gameType,
                        style: AppTextStyles.headline3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getChallengeTypeText(),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText().toUpperCase(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (widget.challenge.wager != null && widget.challenge.wager! > 0) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.neonGreen, AppColors.success],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGreen.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${widget.challenge.wager!.toStringAsFixed(0)} Prize',
                      style: AppTextStyles.headline4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Challenge Info',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Challenger', _getChallengerName(), Icons.person),
            const SizedBox(height: 12),
            _buildInfoRow('Opponent', _getOpponentName(), Icons.person_outline),
            const SizedBox(height: 12),
            _buildInfoRow('Type', _getChallengeTypeText(), Icons.category),
            const SizedBox(height: 12),
            _buildInfoRow('Created', _getFormattedDate(widget.challenge.createdAt), Icons.schedule),
            if (widget.challenge.acceptedAt != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('Accepted', _getFormattedDate(widget.challenge.acceptedAt!), Icons.check_circle),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTextStyles.labelMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 12),
            Text(
              widget.challenge.description!,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Game Settings',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 12),
            ...widget.challenge.gameSettings!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatSettingName(entry.key),
                      style: AppTextStyles.labelMedium,
                    ),
                    Text(
                      entry.value.toString(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildTimeline() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Challenge Timeline',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              'Challenge Created',
              widget.challenge.createdAt,
              Icons.create,
              isCompleted: true,
            ),
            if (widget.challenge.acceptedAt != null)
              _buildTimelineItem(
                'Challenge Accepted',
                widget.challenge.acceptedAt!,
                Icons.check_circle,
                isCompleted: true,
              ),
            if (widget.challenge.status == ChallengeStatus.ongoing)
              _buildTimelineItem(
                'Match In Progress',
                DateTime.now(),
                Icons.play_circle,
                isCompleted: false,
                isActive: true,
              ),
            if (widget.challenge.completedAt != null)
              _buildTimelineItem(
                'Challenge Completed',
                widget.challenge.completedAt!,
                Icons.flag,
                isCompleted: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    DateTime dateTime,
    IconData icon, {
    bool isCompleted = false,
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success.withValues(alpha: 0.2)
                  : isActive
                      ? AppColors.warning.withValues(alpha: 0.2)
                      : AppColors.onSurfaceSecondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isCompleted
                  ? AppColors.success
                  : isActive
                      ? AppColors.warning
                      : AppColors.onSurfaceSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getFormattedDate(dateTime),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final isMyChallenge = widget.challenge.challengerId == 'auth_user_1';
    final isChallengedUser = widget.challenge.challengedUserId == 'auth_user_1';
    final canAccept = (isChallengedUser || widget.challenge.type == ChallengeType.public) &&
        widget.challenge.status == ChallengeStatus.pending &&
        !isMyChallenge;

    if (!canAccept && widget.challenge.status != ChallengeStatus.accepted) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.borderColor, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (canAccept) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: _declineChallenge,
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _acceptChallenge,
                  child: const Text('Accept Challenge'),
                ),
              ),
            ] else if (widget.challenge.status == ChallengeStatus.accepted) ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: _startMatch,
                  child: const Text('Start Match'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _acceptChallenge() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Challenge accepted! Get ready to play.'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  void _declineChallenge() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Challenge declined.'),
        backgroundColor: AppColors.error,
      ),
    );
    Navigator.pop(context);
  }

  void _startMatch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Match started! Good luck!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _getChallengerName() {
    if (widget.challenge.challengerId == 'auth_user_1') {
      return 'You';
    }
    return 'Player${widget.challenge.challengerId.split('_').last}';
  }

  String _getOpponentName() {
    if (widget.challenge.type == ChallengeType.public) {
      return 'Open to anyone';
    }

    if (widget.challenge.challengedUserId == null) {
      return 'Open to anyone';
    }

    if (widget.challenge.challengedUserId == 'auth_user_1') {
      return 'You';
    }

    return 'Player${widget.challenge.challengedUserId!.split('_').last}';
  }

  String _getChallengeTypeText() {
    switch (widget.challenge.type) {
      case ChallengeType.oneVsOne:
        return '1v1 Challenge';
      case ChallengeType.team:
        return 'Team Challenge';
      case ChallengeType.public:
        return 'Open Challenge';
    }
  }

  String _getStatusText() {
    switch (widget.challenge.status) {
      case ChallengeStatus.pending:
        return 'Open';
      case ChallengeStatus.accepted:
        return 'Accepted';
      case ChallengeStatus.ongoing:
        return 'Playing';
      case ChallengeStatus.completed:
        return 'Completed';
      case ChallengeStatus.rejected:
        return 'Rejected';
      case ChallengeStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _getFormattedDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatSettingName(String key) {
    return key.split(RegExp(r'(?=[A-Z])')).map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Color _getStatusColor() {
    switch (widget.challenge.status) {
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

    return gameGradients[widget.challenge.gameType] ?? AppColors.primaryGradient;
  }

  IconData _getGameIcon() {
    final Map<String, IconData> gameIcons = {
      'PES Mobile 2026': Icons.sports_soccer,
      'PUBG Mobile': Icons.gps_fixed,
      'Free Fire': Icons.local_fire_department,
      'Call of Duty Mobile': Icons.gps_fixed,
    };

    return gameIcons[widget.challenge.gameType] ?? Icons.sports_mma;
  }
}