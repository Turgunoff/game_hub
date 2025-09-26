import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/services/static_data_service.dart';
import '../../../../core/data/models/activity.dart';
import '../../../../injection_container.dart';
import '../widgets/stats_card.dart';
import '../widgets/activity_card.dart';
import '../widgets/quick_action_card.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final StaticDataService _dataService = getIt<StaticDataService>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = _dataService.currentUserProfile;
    final activities = _dataService.recentActivities;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: CustomScrollView(
              slivers: [
              _buildAppBar(profile),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildWelcomeSection(profile),
                    const SizedBox(height: 24),
                    _buildQuickStats(profile),
                    const SizedBox(height: 24),
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildRecentActivities(activities),
                    const SizedBox(height: 100), // Bottom padding for navigation
                  ]),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(dynamic profile) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.gameGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Icon(
                          Icons.person,
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
                              'Welcome back!',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              profile.displayName,
                              style: AppTextStyles.headline4.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        title: Text(
          'Game Hub',
          style: AppTextStyles.headline4.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildWelcomeSection(dynamic profile) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.secondary.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${profile.level}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ready for your next challenge?',
                    style: AppTextStyles.headline4,
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (profile.experience % 1000) / 1000,
                    backgroundColor: AppColors.borderColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonGreen),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'XP: ${profile.experience % 1000}/1000',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(dynamic profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: AppTextStyles.headline4,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: Tween<double>(begin: 0.8, end: 1.0)
                        .animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(0.2, 0.6, curve: Curves.elasticOut),
                        ))
                        .value,
                    child: StatsCard(
                      title: 'Games Played',
                      value: profile.gamesPlayed.toString(),
                      icon: Icons.sports_esports,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: Tween<double>(begin: 0.8, end: 1.0)
                        .animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(0.3, 0.7, curve: Curves.elasticOut),
                        ))
                        .value,
                    child: StatsCard(
                      title: 'Win Rate',
                      value: '${profile.winRate.toStringAsFixed(1)}%',
                      icon: Icons.trending_up,
                      color: AppColors.success,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Wins',
                value: profile.gamesWon.toString(),
                icon: Icons.emoji_events,
                color: AppColors.neonGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'Level',
                value: profile.level.toString(),
                icon: Icons.star,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.headline4,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                title: 'Find Match',
                subtitle: 'Start playing now',
                icon: Icons.play_arrow,
                gradient: AppColors.primaryGradient,
                onTap: () {
                  _navigateToTab(1); // Games tab
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                title: 'Tournaments',
                subtitle: 'Join competitions',
                icon: Icons.emoji_events,
                gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.neonOrange],
                ),
                onTap: () {
                  _navigateToTab(2); // Tournaments tab
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                title: 'Challenges',
                subtitle: '1v1 battles',
                icon: Icons.sports_mma,
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, AppColors.neonBlue],
                ),
                onTap: () {
                  _navigateToTab(3); // Challenges tab
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                title: 'Leaderboard',
                subtitle: 'Check rankings',
                icon: Icons.leaderboard,
                gradient: const LinearGradient(
                  colors: [AppColors.neonGreen, AppColors.success],
                ),
                onTap: () {
                  _navigateToTab(4); // Rating/Leaderboard tab
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivities(List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
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
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.take(5).length,
          itemBuilder: (context, index) {
            return ActivityCard(activity: activities[index]);
          },
        ),
      ],
    );
  }

  void _navigateToTab(int tabIndex) {
    // Show user feedback with nice animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getTabIcon(tabIndex),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text('Opening ${_getTabName(tabIndex)}...'),
          ],
        ),
        duration: const Duration(milliseconds: 1200),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Go',
          textColor: Colors.white,
          onPressed: () {
            // Here you could implement actual navigation
            // For now it's just visual feedback
          },
        ),
      ),
    );
  }

  IconData _getTabIcon(int index) {
    switch (index) {
      case 1: return Icons.sports_esports;
      case 2: return Icons.emoji_events;
      case 3: return Icons.sports_mma;
      case 4: return Icons.leaderboard;
      default: return Icons.home;
    }
  }

  String _getTabName(int index) {
    switch (index) {
      case 1: return 'Games';
      case 2: return 'Tournaments';
      case 3: return 'Challenges';
      case 4: return 'Leaderboard';
      default: return 'Home';
    }
  }
}