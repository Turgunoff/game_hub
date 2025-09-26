import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/services/static_data_service.dart';
import '../../../../core/data/models/game.dart';
import '../../../../injection_container.dart';
import '../widgets/game_card.dart';
import '../widgets/game_category_chip.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final StaticDataService _dataService = getIt<StaticDataService>();

  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<String> get _categories => [
        'All',
        'Popular',
        ...Set.from(_dataService.games.map((game) => game.category))
      ];

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredGames = _getFilteredGames();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Games',
          style: AppTextStyles.headline3,
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilter(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshGames,
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _animationController,
                    child: _buildGamesList(filteredGames),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search games...',
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.onSurfaceSecondary,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.onSurfaceSecondary,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GameCategoryChip(
            label: category,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildGamesList(List<Game> games) {
    if (games.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.onSurfaceSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No games found',
              style: AppTextStyles.headline4.copyWith(
                color: AppColors.onSurfaceSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: games.length,
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
                child: GameCard(
                  game: games[index],
                  onTap: () => _showGameDetails(games[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Game> _getFilteredGames() {
    var games = _dataService.games;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      games = games.where((game) {
        return game.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            game.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            game.category.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Filter by category
    if (_selectedCategory != 'All') {
      if (_selectedCategory == 'Popular') {
        games = games.where((game) => game.isPopular).toList();
      } else {
        games = games.where((game) => game.category == _selectedCategory).toList();
      }
    }

    // Sort by popularity and rating
    games.sort((a, b) {
      if (a.isPopular && !b.isPopular) return -1;
      if (!a.isPopular && b.isPopular) return 1;
      return b.rating.compareTo(a.rating);
    });

    return games;
  }

  Future<void> _refreshGames() async {
    // Simulate API refresh delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.refresh, color: Colors.white),
            const SizedBox(width: 8),
            Text('Games refreshed!'),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showGameDetails(Game game) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildGameDetailsBottomSheet(game),
    );
  }

  Widget _buildGameDetailsBottomSheet(Game game) {
    return Container(
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Icon(
                          Icons.sports_esports,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.name,
                              style: AppTextStyles.headline3,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              game.category,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: AppColors.neonGreen,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  game.rating.toString(),
                                  style: AppTextStyles.labelMedium,
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.people,
                                  color: AppColors.onSurfaceSecondary,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${(game.playerCount / 1000000).toStringAsFixed(1)}M',
                                  style: AppTextStyles.labelMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: AppTextStyles.headline4,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.description,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Features',
                    style: AppTextStyles.headline4,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: game.features.map((feature) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          feature,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showGameModes(game);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play Now'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGameModes(Game game) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Game Mode',
                    style: AppTextStyles.headline4,
                  ),
                  const SizedBox(height: 20),
                  _buildGameModeOption(
                    'Quick Match',
                    'Find a random opponent',
                    Icons.flash_on,
                    AppColors.primary,
                    () => _startQuickMatch(game),
                  ),
                  _buildGameModeOption(
                    'Tournament',
                    'Join a tournament',
                    Icons.emoji_events,
                    AppColors.accent,
                    () => _joinTournament(game),
                  ),
                  _buildGameModeOption(
                    'Challenge',
                    'Create or accept a challenge',
                    Icons.sports_mma,
                    AppColors.secondary,
                    () => _createChallenge(game),
                  ),
                  _buildGameModeOption(
                    'Practice',
                    'Play against AI',
                    Icons.psychology,
                    AppColors.success,
                    () => _startPractice(game),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameModeOption(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: AppTextStyles.labelLarge),
        subtitle: Text(description, style: AppTextStyles.bodySmall),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  void _startQuickMatch(Game game) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting quick match for ${game.name}...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _joinTournament(Game game) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Looking for ${game.name} tournaments...'),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  void _createChallenge(Game game) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating ${game.name} challenge...'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  void _startPractice(Game game) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting practice mode for ${game.name}...'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}