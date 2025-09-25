import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/services/static_data_service.dart';
import '../../../../injection_container.dart';
import '../widgets/challenge_card.dart';
import '../widgets/challenge_filter_chip.dart';
import '../widgets/create_challenge_fab.dart';
import 'challenge_details_page.dart';
import 'create_challenge_page.dart';
import '../../domain/entities/challenge.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final StaticDataService _dataService = getIt<StaticDataService>();

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Open', 'My Challenges', 'Pending', 'Active'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    final challenges = _getFilteredChallenges();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Challenges',
          style: AppTextStyles.headline3,
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showChallengeHistory(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animationController,
                  child: _buildChallengesList(challenges),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CreateChallengeFAB(
        onPressed: () => _navigateToCreateChallenge(),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          return ChallengeFilterChip(
            label: filter,
            isSelected: filter == _selectedFilter,
            count: _getFilterCount(filter),
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildChallengesList(List<Challenge> challenges) {
    if (challenges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_mma_outlined,
              size: 64,
              color: AppColors.onSurfaceSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No challenges found',
              style: AppTextStyles.headline4.copyWith(
                color: AppColors.onSurfaceSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptyMessage(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final animation = Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  (index * 0.1).clamp(0.0, 1.0),
                  ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                  curve: Curves.easeOutBack,
                ),
              ),
            );

            return Transform.scale(
              scale: animation.value,
              child: ChallengeCard(
                challenge: challenges[index],
                onTap: () => _navigateToChallengeDetails(challenges[index]),
              ),
            );
          },
        );
      },
    );
  }

  List<Challenge> _getFilteredChallenges() {
    var challenges = _dataService.challenges;

    if (_selectedFilter != 'All') {
      challenges = challenges.where((challenge) {
        switch (_selectedFilter) {
          case 'Open':
            return challenge.type == ChallengeType.public &&
                challenge.status == ChallengeStatus.pending;
          case 'My Challenges':
            return challenge.challengerId == 'auth_user_1' ||
                challenge.challengedUserId == 'auth_user_1';
          case 'Pending':
            return challenge.status == ChallengeStatus.pending;
          case 'Active':
            return challenge.status == ChallengeStatus.accepted ||
                challenge.status == ChallengeStatus.ongoing;
          default:
            return true;
        }
      }).toList();
    }

    // Sort by creation date, newest first
    challenges.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return challenges;
  }

  int _getFilterCount(String filter) {
    final challenges = _dataService.challenges;
    switch (filter) {
      case 'All':
        return challenges.length;
      case 'Open':
        return challenges.where((c) =>
          c.type == ChallengeType.public && c.status == ChallengeStatus.pending
        ).length;
      case 'My Challenges':
        return challenges.where((c) =>
          c.challengerId == 'auth_user_1' || c.challengedUserId == 'auth_user_1'
        ).length;
      case 'Pending':
        return challenges.where((c) => c.status == ChallengeStatus.pending).length;
      case 'Active':
        return challenges.where((c) =>
          c.status == ChallengeStatus.accepted || c.status == ChallengeStatus.ongoing
        ).length;
      default:
        return 0;
    }
  }

  String _getEmptyMessage() {
    switch (_selectedFilter) {
      case 'Open':
        return 'No open challenges available. Create one to get started!';
      case 'My Challenges':
        return 'You have no challenges yet. Create or accept challenges to see them here.';
      case 'Pending':
        return 'No pending challenges. Check back later or create a new one!';
      case 'Active':
        return 'No active challenges. Accept a challenge to start competing!';
      default:
        return 'No challenges found. Create your first challenge!';
    }
  }

  void _navigateToChallengeDetails(Challenge challenge) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeDetailsPage(challenge: challenge),
      ),
    );
  }

  void _navigateToCreateChallenge() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateChallengePage(),
      ),
    );
  }

  void _showChallengeHistory() {
    // Show completed challenges
    final completedChallenges = _dataService.challenges
        .where((c) => c.status == ChallengeStatus.completed)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColors.onSurfaceSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Challenge History',
                style: AppTextStyles.headline3,
              ),
            ),
            Expanded(
              child: completedChallenges.isEmpty
                  ? const Center(
                      child: Text('No completed challenges yet'),
                    )
                  : ListView.builder(
                      itemCount: completedChallenges.length,
                      itemBuilder: (context, index) {
                        final challenge = completedChallenges[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: challenge.winnerId == 'auth_user_1'
                                ? AppColors.success
                                : AppColors.error,
                            child: Icon(
                              challenge.winnerId == 'auth_user_1'
                                  ? Icons.emoji_events
                                  : Icons.close,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(challenge.gameType),
                          subtitle: Text(
                            challenge.winnerId == 'auth_user_1'
                                ? 'Victory'
                                : 'Defeat',
                          ),
                          trailing: Text(
                            '\$${challenge.wager?.toStringAsFixed(0) ?? '0'}',
                            style: TextStyle(
                              color: challenge.winnerId == 'auth_user_1'
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}