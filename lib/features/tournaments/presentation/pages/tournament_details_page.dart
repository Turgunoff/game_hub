import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/tournament.dart';

class TournamentDetailsPage extends StatefulWidget {
  final Tournament tournament;

  const TournamentDetailsPage({super.key, required this.tournament});

  @override
  State<TournamentDetailsPage> createState() => _TournamentDetailsPageState();
}

class _TournamentDetailsPageState extends State<TournamentDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isJoined = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _animationController,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTournamentInfo(),
                    const SizedBox(height: 24),
                    _buildPrizePool(),
                    const SizedBox(height: 24),
                    _buildParticipants(),
                    const SizedBox(height: 24),
                    _buildSchedule(),
                    const SizedBox(height: 24),
                    _buildRules(),
                    const SizedBox(height: 24),
                    _buildParticipantsList(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.surface,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.tournament.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getStatusColor(),
                _getStatusColor().withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.tournament.gameType,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.tournament.status.name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTournamentInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tournament Info',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            Text(
              widget.tournament.description,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoItem(
                  'Entry Fee',
                  '\$${widget.tournament.entryFee.toStringAsFixed(0)}',
                  Icons.attach_money,
                  AppColors.neonGreen,
                ),
                const SizedBox(width: 16),
                _buildInfoItem(
                  'Max Players',
                  widget.tournament.maxParticipants.toString(),
                  Icons.people,
                  AppColors.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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
              label,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrizePool() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppColors.accent.withValues(alpha: 0.1),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: AppColors.accent,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Prize Pool',
                  style: AppTextStyles.headline4,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    '\$${widget.tournament.prizePool.toStringAsFixed(0)}',
                    style: AppTextStyles.headline2.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Total Prize Pool',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurfaceSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildPrizeDistribution(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrizeDistribution() {
    final prizes = [
      {'place': '1st Place', 'amount': widget.tournament.prizePool * 0.5, 'color': AppColors.neonGreen},
      {'place': '2nd Place', 'amount': widget.tournament.prizePool * 0.3, 'color': AppColors.secondary},
      {'place': '3rd Place', 'amount': widget.tournament.prizePool * 0.2, 'color': AppColors.accent},
    ];

    return Column(
      children: prizes.map((prize) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: (prize['color'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                prize['place'] as String,
                style: AppTextStyles.labelMedium,
              ),
              Text(
                '\$${(prize['amount'] as double).toStringAsFixed(0)}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: prize['color'] as Color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildParticipants() {
    final progress = widget.tournament.currentParticipants / widget.tournament.maxParticipants;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Participants',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.tournament.currentParticipants} joined',
                  style: AppTextStyles.labelLarge,
                ),
                Text(
                  '${widget.tournament.maxParticipants - widget.tournament.currentParticipants} spots left',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.onSurfaceSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedule() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            _buildScheduleItem(
              'Registration Deadline',
              widget.tournament.registrationDeadline,
              Icons.app_registration,
            ),
            _buildScheduleItem(
              'Tournament Start',
              widget.tournament.startDate,
              Icons.play_arrow,
            ),
            _buildScheduleItem(
              'Tournament End',
              widget.tournament.endDate,
              Icons.flag,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String title, DateTime date, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelMedium,
              ),
              Text(
                '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRules() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tournament Rules',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 16),
            ...widget.tournament.rules.map((rule) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6, right: 12),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rule,
                        style: AppTextStyles.bodyMedium,
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

  Widget _buildParticipantsList() {
    // Mock participants data
    final participants = List.generate(
      widget.tournament.currentParticipants.clamp(0, 10),
      (index) => {
        'name': 'Player${index + 1}',
        'rating': 1500 + (index * 50),
        'avatar': null,
      },
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Participants',
                  style: AppTextStyles.headline4,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...participants.take(5).map((participant) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(
                    participant['name'].toString().substring(0, 1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  participant['name'] as String,
                  style: AppTextStyles.labelMedium,
                ),
                subtitle: Text(
                  'Rating: ${participant['rating']}',
                  style: AppTextStyles.bodySmall,
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'JOINED',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final canJoin = widget.tournament.status == TournamentStatus.upcoming &&
        widget.tournament.currentParticipants < widget.tournament.maxParticipants &&
        DateTime.now().isBefore(widget.tournament.registrationDeadline);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.borderColor, width: 1),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canJoin ? _toggleJoin : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isJoined ? AppColors.error : AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              _getButtonText(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getButtonText() {
    if (!DateTime.now().isBefore(widget.tournament.registrationDeadline)) {
      return 'Registration Closed';
    }

    if (widget.tournament.currentParticipants >= widget.tournament.maxParticipants) {
      return 'Tournament Full';
    }

    switch (widget.tournament.status) {
      case TournamentStatus.upcoming:
        return _isJoined ? 'Leave Tournament' : 'Join Tournament';
      case TournamentStatus.ongoing:
        return 'Tournament In Progress';
      case TournamentStatus.completed:
        return 'Tournament Completed';
      case TournamentStatus.cancelled:
        return 'Tournament Cancelled';
    }
  }

  void _toggleJoin() {
    setState(() {
      _isJoined = !_isJoined;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isJoined
              ? 'Successfully joined tournament!'
              : 'Left tournament',
        ),
        backgroundColor: _isJoined ? AppColors.success : AppColors.error,
      ),
    );
  }

  Color _getStatusColor() {
    switch (widget.tournament.status) {
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
}