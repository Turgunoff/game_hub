import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/services/static_data_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../injection_container.dart';
import '../widgets/game_rating_overview.dart';
import '../widgets/leaderboard_tab.dart';
import '../widgets/rating_history_tab.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StaticDataService _dataService = getIt<StaticDataService>();
  String _selectedGame = AppConstants.gameTypes.first;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rating & Leaderboards',
          style: AppTextStyles.headline3,
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard, size: 20)),
            Tab(text: 'Leaderboard', icon: Icon(Icons.leaderboard, size: 20)),
            Tab(text: 'History', icon: Icon(Icons.history, size: 20)),
          ],
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceSecondary,
        ),
      ),
      body: Column(
        children: [
          _buildGameSelector(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                GameRatingOverview(
                  selectedGame: _selectedGame,
                  userRatings: _dataService.userRatings,
                ),
                LeaderboardTab(
                  selectedGame: _selectedGame,
                  topPlayers: _dataService.getTopPlayers(_selectedGame),
                ),
                RatingHistoryTab(
                  selectedGame: _selectedGame,
                  userRatings: _dataService.userRatings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameSelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.gameTypes.length,
        itemBuilder: (context, index) {
          final game = AppConstants.gameTypes[index];
          final isSelected = game == _selectedGame;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedGame = game;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? _getGameGradient(game) : null,
                color: isSelected ? null : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? null : Border.all(
                  color: AppColors.borderColor,
                  width: 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: _getGameGradient(game).colors.first.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ] : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getGameIcon(game),
                    color: isSelected ? Colors.white : AppColors.onSurface,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getShortGameName(game),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getShortGameName(String game) {
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

    return gameShorts[game] ?? game;
  }

  LinearGradient _getGameGradient(String game) {
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
      'Mobile Legends': const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryDark],
      ),
      'Clash Royale': const LinearGradient(
        colors: [AppColors.neonPink, AppColors.accent],
      ),
      'Brawl Stars': const LinearGradient(
        colors: [AppColors.neonGreen, AppColors.success],
      ),
      'Fortnite Mobile': const LinearGradient(
        colors: [AppColors.primary, AppColors.secondary],
      ),
    };

    return gameGradients[game] ?? AppColors.primaryGradient;
  }

  IconData _getGameIcon(String game) {
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

    return gameIcons[game] ?? Icons.sports_esports;
  }
}