import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/services/static_data_service.dart';
import '../../../../injection_container.dart';
import '../widgets/tournament_card.dart';
import '../widgets/tournament_filter_chip.dart';
import '../widgets/create_tournament_fab.dart';
import 'tournament_details_page.dart';
import 'create_tournament_page.dart';
import '../../domain/entities/tournament.dart';

class TournamentsPage extends StatefulWidget {
  const TournamentsPage({super.key});

  @override
  State<TournamentsPage> createState() => _TournamentsPageState();
}

class _TournamentsPageState extends State<TournamentsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final StaticDataService _dataService = getIt<StaticDataService>();

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Upcoming', 'Ongoing', 'Completed'];

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
    final tournaments = _getFilteredTournaments();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tournaments',
          style: AppTextStyles.headline3,
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(),
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
                  child: _buildTournamentsList(tournaments),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CreateTournamentFAB(
        onPressed: () => _navigateToCreateTournament(),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                return TournamentFilterChip(
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
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentsList(List<Tournament> tournaments) {
    if (tournaments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: AppColors.onSurfaceSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No tournaments found',
              style: AppTextStyles.headline4.copyWith(
                color: AppColors.onSurfaceSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your own tournament or check back later',
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
      itemCount: tournaments.length,
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
              child: TournamentCard(
                tournament: tournaments[index],
                onTap: () => _navigateToTournamentDetails(tournaments[index]),
              ),
            );
          },
        );
      },
    );
  }

  List<Tournament> _getFilteredTournaments() {
    var tournaments = _dataService.tournaments;

    if (_selectedFilter != 'All') {
      tournaments = tournaments.where((tournament) {
        switch (_selectedFilter) {
          case 'Upcoming':
            return tournament.status == TournamentStatus.upcoming;
          case 'Ongoing':
            return tournament.status == TournamentStatus.ongoing;
          case 'Completed':
            return tournament.status == TournamentStatus.completed;
          default:
            return true;
        }
      }).toList();
    }

    // Sort by start date
    tournaments.sort((a, b) {
      if (a.status != b.status) {
        // Ongoing first, then upcoming, then completed
        final statusOrder = {
          TournamentStatus.ongoing: 0,
          TournamentStatus.upcoming: 1,
          TournamentStatus.completed: 2,
          TournamentStatus.cancelled: 3,
        };
        return statusOrder[a.status]!.compareTo(statusOrder[b.status]!);
      }
      return a.startDate.compareTo(b.startDate);
    });

    return tournaments;
  }

  int _getFilterCount(String filter) {
    final tournaments = _dataService.tournaments;
    switch (filter) {
      case 'All':
        return tournaments.length;
      case 'Upcoming':
        return tournaments.where((t) => t.status == TournamentStatus.upcoming).length;
      case 'Ongoing':
        return tournaments.where((t) => t.status == TournamentStatus.ongoing).length;
      case 'Completed':
        return tournaments.where((t) => t.status == TournamentStatus.completed).length;
      default:
        return 0;
    }
  }

  void _navigateToTournamentDetails(Tournament tournament) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TournamentDetailsPage(tournament: tournament),
      ),
    );
  }

  void _navigateToCreateTournament() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTournamentPage(),
      ),
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: TournamentSearchDelegate(_dataService.tournaments),
    );
  }
}

class TournamentSearchDelegate extends SearchDelegate<Tournament?> {
  final List<Tournament> tournaments;

  TournamentSearchDelegate(this.tournaments);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = tournaments.where((tournament) {
      return tournament.name.toLowerCase().contains(query.toLowerCase()) ||
          tournament.gameType.toLowerCase().contains(query.toLowerCase()) ||
          tournament.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text('No tournaments found'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final tournament = results[index];
        return ListTile(
          title: Text(tournament.name),
          subtitle: Text(tournament.gameType),
          trailing: Text(tournament.status.name),
          onTap: () => close(context, tournament),
        );
      },
    );
  }
}