import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/services/static_data_service.dart';
import '../../../../injection_container.dart';
import '../widgets/profile_stat_card.dart';
import '../widgets/game_rating_card.dart';
import '../widgets/achievement_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  final StaticDataService _dataService = getIt<StaticDataService>();

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
    final profile = _dataService.currentUserProfile;
    final ratings = _dataService.userRatings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditProfile(context, profile),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _animationController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(profile),
              const SizedBox(height: 24),
              _buildStatsSection(profile),
              const SizedBox(height: 24),
              _buildGameRatingsSection(ratings),
              const SizedBox(height: 24),
              _buildAchievementsSection(),
              const SizedBox(height: 24),
              _buildRecentGamesSection(),
              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(profile) {
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
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        border: Border.all(color: AppColors.primary, width: 3),
                      ),
                      child: profile.avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                profile.avatarUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.surface, width: 2),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.displayName,
                        style: AppTextStyles.headline3,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Level ${profile.level}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• Gaming Master',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.onSurfaceSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.bio ?? 'No bio available',
                        style: AppTextStyles.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickStat('XP', profile.experience.toString()),
                  _buildQuickStat('Win Rate', '${profile.winRate.toStringAsFixed(1)}%'),
                  _buildQuickStat('Rank', '#245'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildStatsSection(profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: AppTextStyles.headline4,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ProfileStatCard(
                title: 'Games Played',
                value: profile.gamesPlayed.toString(),
                icon: Icons.games,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileStatCard(
                title: 'Games Won',
                value: profile.gamesWon.toString(),
                icon: Icons.emoji_events,
                color: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ProfileStatCard(
                title: 'Win Rate',
                value: '${profile.winRate.toStringAsFixed(1)}%',
                icon: Icons.trending_up,
                color: AppColors.neonGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileStatCard(
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

  Widget _buildGameRatingsSection(ratings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Game Ratings',
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
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ratings.take(5).length,
            itemBuilder: (context, index) {
              return GameRatingCard(rating: ratings[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    final achievements = [
      {'title': 'Tournament Champion', 'desc': 'Won Weekly Championship', 'icon': Icons.military_tech, 'color': AppColors.accent, 'time': '2 days ago'},
      {'title': 'Winning Streak', 'desc': '10 consecutive wins', 'icon': Icons.local_fire_department, 'color': AppColors.neonGreen, 'time': '1 week ago'},
      {'title': 'First Victory', 'desc': 'Your first game win', 'icon': Icons.emoji_events, 'color': AppColors.success, 'time': '2 months ago'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Achievements',
          style: AppTextStyles.headline4,
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return AchievementItem(
              title: achievement['title'] as String,
              description: achievement['desc'] as String,
              icon: achievement['icon'] as IconData,
              color: achievement['color'] as Color,
              time: achievement['time'] as String,
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentGamesSection() {
    final recentGames = [
      {'opponent': 'PlayerX', 'game': 'PES Mobile', 'result': 'Victory', 'score': '3-1', 'time': '2 hours ago', 'won': true},
      {'opponent': 'GamerY', 'game': 'PUBG Mobile', 'result': 'Defeat', 'score': '2nd Place', 'time': '5 hours ago', 'won': false},
      {'opponent': 'ProZ', 'game': 'Free Fire', 'result': 'Victory', 'score': '1st Place', 'time': '1 day ago', 'won': true},
      {'opponent': 'PlayerA', 'game': 'COD Mobile', 'result': 'Defeat', 'score': '15-20', 'time': '2 days ago', 'won': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Games',
          style: AppTextStyles.headline4,
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentGames.length,
          itemBuilder: (context, index) {
            final game = recentGames[index];
            final won = game['won'] as bool;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: won ? AppColors.success.withValues(alpha: 0.2) : AppColors.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    won ? Icons.check : Icons.close,
                    color: won ? AppColors.success : AppColors.error,
                  ),
                ),
                title: Text(
                  'vs. ${game['opponent']}',
                  style: AppTextStyles.labelLarge,
                ),
                subtitle: Text(
                  '${game['game']} • ${game['time']}',
                  style: AppTextStyles.bodySmall,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      game['result'] as String,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: won ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      game['score'] as String,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showEditProfile(BuildContext context, profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEditProfileBottomSheet(profile),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsBottomSheet(),
    );
  }

  Widget _buildEditProfileBottomSheet(profile) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Edit Profile',
              style: AppTextStyles.headline3,
            ),
            const SizedBox(height: 24),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              initialValue: profile.displayName,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: profile.bio,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Bio',
                prefixIcon: Icon(Icons.info_outline),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsBottomSheet() {
    final settings = [
      {'title': 'Notifications', 'icon': Icons.notifications_outlined, 'trailing': Icons.toggle_on},
      {'title': 'Privacy', 'icon': Icons.lock_outline, 'trailing': Icons.arrow_forward_ios},
      {'title': 'Game Preferences', 'icon': Icons.settings_outlined, 'trailing': Icons.arrow_forward_ios},
      {'title': 'Help & Support', 'icon': Icons.help_outline, 'trailing': Icons.arrow_forward_ios},
      {'title': 'About', 'icon': Icons.info_outline, 'trailing': Icons.arrow_forward_ios},
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
              'Settings',
              style: AppTextStyles.headline3,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: settings.length,
              itemBuilder: (context, index) {
                final setting = settings[index];
                return ListTile(
                  leading: Icon(
                    setting['icon'] as IconData,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    setting['title'] as String,
                    style: AppTextStyles.labelLarge,
                  ),
                  trailing: Icon(
                    setting['trailing'] as IconData,
                    color: setting['trailing'] == Icons.toggle_on
                        ? AppColors.success
                        : AppColors.onSurfaceSecondary,
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}