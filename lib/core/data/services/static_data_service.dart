import 'dart:math';
import 'package:injectable/injectable.dart';
import '../models/game.dart';
import '../models/activity.dart';
import '../../../features/profile/domain/entities/profile.dart';
import '../../../features/tournaments/domain/entities/tournament.dart';
import '../../../features/challenges/domain/entities/challenge.dart';
import '../../../features/rating/domain/entities/rating.dart';
import '../../constants/app_constants.dart';

@singleton
class StaticDataService {
  final Random _random = Random();

  // Current user profile
  Profile get currentUserProfile => Profile(
        id: 'user_1',
        userId: 'auth_user_1',
        displayName: 'GamerPro2024',
        bio: 'Competitive gamer who loves challenges and tournaments!',
        avatarUrl: null,
        gamesPlayed: 247,
        gamesWon: 189,
        winRate: 76.5,
        level: 28,
        experience: 15420,
        createdAt: DateTime.fromMillisecondsSinceEpoch(1698825600000), // Example timestamp
        updatedAt: DateTime.fromMillisecondsSinceEpoch(1704067200000), // Example timestamp
      );

  // Games data
  List<Game> get games => [
        const Game(
          id: 'pes_2026',
          name: 'PES Mobile 2026',
          description: 'The ultimate football experience on mobile',
          imageUrl: 'assets/games/pes_mobile.jpg',
          category: 'Sports',
          playerCount: 2500000,
          isPopular: true,
          features: ['Real-time PvP', '1v1 Matches', 'Tournaments'],
          rating: 4.6,
        ),
        const Game(
          id: 'pubg_mobile',
          name: 'PUBG Mobile',
          description: 'Battle royale on your mobile device',
          imageUrl: 'assets/games/pubg_mobile.jpg',
          category: 'Battle Royale',
          playerCount: 10000000,
          isPopular: true,
          features: ['100 Players', 'Squad Mode', 'Ranked Matches'],
          rating: 4.4,
        ),
        const Game(
          id: 'free_fire',
          name: 'Free Fire',
          description: 'Fast-paced battle royale experience',
          imageUrl: 'assets/games/free_fire.jpg',
          category: 'Battle Royale',
          playerCount: 8000000,
          isPopular: true,
          features: ['Quick Matches', '50 Players', 'Unique Characters'],
          rating: 4.2,
        ),
        const Game(
          id: 'cod_mobile',
          name: 'Call of Duty Mobile',
          description: 'Iconic COD experience on mobile',
          imageUrl: 'assets/games/cod_mobile.jpg',
          category: 'Shooter',
          playerCount: 5000000,
          isPopular: true,
          features: ['Multiplayer', 'Battle Royale', 'Zombies'],
          rating: 4.5,
        ),
        const Game(
          id: 'mobile_legends',
          name: 'Mobile Legends',
          description: 'MOBA game with 5v5 battles',
          imageUrl: 'assets/games/mobile_legends.jpg',
          category: 'MOBA',
          playerCount: 6000000,
          isPopular: true,
          features: ['5v5 Battles', 'Heroes', 'Real-time Strategy'],
          rating: 4.3,
        ),
        const Game(
          id: 'clash_royale',
          name: 'Clash Royale',
          description: 'Real-time strategy battles',
          imageUrl: 'assets/games/clash_royale.jpg',
          category: 'Strategy',
          playerCount: 3000000,
          isPopular: false,
          features: ['Card Battles', '1v1', 'Clan Wars'],
          rating: 4.1,
        ),
        const Game(
          id: 'brawl_stars',
          name: 'Brawl Stars',
          description: 'Fast-paced multiplayer battles',
          imageUrl: 'assets/games/brawl_stars.jpg',
          category: 'Action',
          playerCount: 2000000,
          isPopular: false,
          features: ['3v3 Battles', 'Multiple Game Modes', 'Brawlers'],
          rating: 4.0,
        ),
        const Game(
          id: 'fortnite',
          name: 'Fortnite Mobile',
          description: 'Build, battle, and be the last one standing',
          imageUrl: 'assets/games/fortnite.jpg',
          category: 'Battle Royale',
          playerCount: 4000000,
          isPopular: false,
          features: ['Building', '100 Players', 'Creative Mode'],
          rating: 3.9,
        ),
      ];

  // Recent activities
  List<Activity> get recentActivities => [
        Activity(
          id: 'activity_1',
          type: ActivityType.game,
          title: 'Victory in PES Mobile 2026',
          description: 'Won against PlayerX with score 3-1',
          gameType: AppConstants.pesMobile,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          metadata: {'score': '3-1', 'opponent': 'PlayerX', 'result': 'win'},
        ),
        Activity(
          id: 'activity_2',
          type: ActivityType.tournament,
          title: 'Joined Weekly Championship',
          description: 'Registered for PUBG Mobile tournament',
          gameType: AppConstants.pubgMobile,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          metadata: {'tournament': 'Weekly Championship', 'fee': 50},
        ),
        Activity(
          id: 'activity_3',
          type: ActivityType.challenge,
          title: 'Challenge Completed',
          description: 'Defeated GamerX in Free Fire 1v1',
          gameType: AppConstants.freeFire,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          metadata: {'opponent': 'GamerX', 'wager': 25, 'result': 'win'},
        ),
        Activity(
          id: 'activity_4',
          type: ActivityType.achievement,
          title: 'New Achievement Unlocked',
          description: 'Earned "Winning Streak" badge',
          gameType: null,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          metadata: {'achievement': 'Winning Streak', 'streak': 5},
        ),
        Activity(
          id: 'activity_5',
          type: ActivityType.rating,
          title: 'Rating Increased',
          description: 'Reached Gold rank in COD Mobile',
          gameType: AppConstants.codMobile,
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          metadata: {'oldRating': 1450, 'newRating': 1520, 'rank': 'Gold'},
        ),
      ];

  // User ratings by game
  List<Rating> get userRatings => AppConstants.gameTypes
      .map((game) => Rating(
            id: 'rating_${game.toLowerCase().replaceAll(' ', '_')}',
            userId: 'auth_user_1',
            gameType: game,
            currentRating: 1200 + _random.nextInt(1500),
            peakRating: 1500 + _random.nextInt(1200),
            gamesPlayed: 20 + _random.nextInt(180),
            wins: 15 + _random.nextInt(120),
            losses: 5 + _random.nextInt(60),
            winRate: 0.6 + (_random.nextDouble() * 0.35),
            rank: _getRankFromRating(1200 + _random.nextInt(1500)),
            rankProgress: _random.nextInt(100),
            lastGameAt: DateTime.now().subtract(Duration(days: _random.nextInt(7))),
            createdAt: DateTime.now().subtract(Duration(days: 30 + _random.nextInt(300))),
            updatedAt: DateTime.now().subtract(Duration(hours: _random.nextInt(48))),
          ))
      .toList();

  // Sample tournaments
  List<Tournament> get tournaments => [
        Tournament(
          id: 'tournament_1',
          name: 'Weekly PES Championship',
          description: 'Compete in the ultimate football tournament',
          gameType: AppConstants.pesMobile,
          format: TournamentFormat.singleElimination,
          maxParticipants: 64,
          currentParticipants: 45,
          entryFee: 50.0,
          prizePool: 2000.0,
          status: TournamentStatus.upcoming,
          startDate: DateTime.now().add(const Duration(days: 2)),
          endDate: DateTime.now().add(const Duration(days: 4)),
          registrationDeadline: DateTime.now().add(const Duration(days: 1)),
          imageUrl: null,
          rules: ['Fair play required', 'No cheating', 'Respect opponents'],
          participants: List.generate(45, (i) => 'Player${i + 1}'),
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Tournament(
          id: 'tournament_2',
          name: 'PUBG Mobile Battle Royale',
          description: 'Squad-based battle royale tournament',
          gameType: AppConstants.pubgMobile,
          format: TournamentFormat.doubleElimination,
          maxParticipants: 100,
          currentParticipants: 78,
          entryFee: 25.0,
          prizePool: 1500.0,
          status: TournamentStatus.ongoing,
          startDate: DateTime.now().subtract(const Duration(hours: 2)),
          endDate: DateTime.now().add(const Duration(hours: 22)),
          registrationDeadline: DateTime.now().subtract(const Duration(hours: 3)),
          imageUrl: null,
          rules: ['Squad of 4 players', 'No third-party tools', 'Follow game rules'],
          participants: List.generate(78, (i) => 'TeamLeader${i + 1}'),
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        Tournament(
          id: 'tournament_3',
          name: 'Free Fire Masters',
          description: 'Solo battle royale championship',
          gameType: AppConstants.freeFire,
          format: TournamentFormat.roundRobin,
          maxParticipants: 50,
          currentParticipants: 32,
          entryFee: 30.0,
          prizePool: 1000.0,
          status: TournamentStatus.upcoming,
          startDate: DateTime.now().add(const Duration(days: 5)),
          endDate: DateTime.now().add(const Duration(days: 6)),
          registrationDeadline: DateTime.now().add(const Duration(days: 4)),
          imageUrl: null,
          rules: ['Solo matches only', 'No teaming', 'Fair play'],
          participants: List.generate(32, (i) => 'SoloPlayer${i + 1}'),
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Tournament(
          id: 'tournament_4',
          name: 'COD Mobile Championship',
          description: 'Multiplayer tournament with multiple game modes',
          gameType: AppConstants.codMobile,
          format: TournamentFormat.swiss,
          maxParticipants: 32,
          currentParticipants: 32,
          entryFee: 75.0,
          prizePool: 1800.0,
          status: TournamentStatus.completed,
          startDate: DateTime.now().subtract(const Duration(days: 3)),
          endDate: DateTime.now().subtract(const Duration(days: 1)),
          registrationDeadline: DateTime.now().subtract(const Duration(days: 4)),
          imageUrl: null,
          rules: ['Team Deathmatch', 'Best of 3 rounds', 'Professional conduct'],
          participants: List.generate(32, (i) => 'CodMaster${i + 1}'),
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ];

  // Sample challenges
  List<Challenge> get challenges => [
        Challenge(
          id: 'challenge_1',
          challengerId: 'user_2',
          challengedUserId: null, // Open challenge
          gameType: AppConstants.pesMobile,
          type: ChallengeType.public,
          status: ChallengeStatus.pending,
          wager: 25.0,
          description: 'Looking for a competitive PES match!',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          acceptedAt: null,
          completedAt: null,
          winnerId: null,
          gameSettings: {'matchLength': '10 minutes', 'difficulty': 'Professional'},
        ),
        Challenge(
          id: 'challenge_2',
          challengerId: 'auth_user_1',
          challengedUserId: 'user_3',
          gameType: AppConstants.pubgMobile,
          type: ChallengeType.oneVsOne,
          status: ChallengeStatus.accepted,
          wager: 50.0,
          description: 'Squad vs Squad PUBG match',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          acceptedAt: DateTime.now().subtract(const Duration(hours: 2)),
          completedAt: null,
          winnerId: null,
          gameSettings: {'mode': 'Erangel', 'perspective': 'TPP'},
        ),
        Challenge(
          id: 'challenge_3',
          challengerId: 'user_4',
          challengedUserId: 'auth_user_1',
          gameType: AppConstants.freeFire,
          type: ChallengeType.oneVsOne,
          status: ChallengeStatus.pending,
          wager: 15.0,
          description: 'Quick Free Fire duel',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          acceptedAt: null,
          completedAt: null,
          winnerId: null,
          gameSettings: {'mode': 'Classic', 'map': 'Bermuda'},
        ),
        Challenge(
          id: 'challenge_4',
          challengerId: 'auth_user_1',
          challengedUserId: 'user_5',
          gameType: AppConstants.codMobile,
          type: ChallengeType.oneVsOne,
          status: ChallengeStatus.completed,
          wager: 40.0,
          description: 'COD Mobile showdown',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          acceptedAt: DateTime.now().subtract(const Duration(hours: 23)),
          completedAt: DateTime.now().subtract(const Duration(hours: 22)),
          winnerId: 'auth_user_1',
          gameSettings: {'mode': 'Team Deathmatch', 'map': 'Nuketown'},
        ),
      ];

  // Top players for leaderboards
  List<Map<String, dynamic>> getTopPlayers(String gameType) {
    return List.generate(50, (index) {
      final rating = 3500 - (index * 50) + _random.nextInt(40);
      return {
        'rank': index + 1,
        'username': 'Player${index + 1}${_random.nextInt(999)}',
        'rating': rating,
        'rank_name': _getRankFromRating(rating),
        'games_played': 100 + _random.nextInt(500),
        'win_rate': (0.5 + (_random.nextDouble() * 0.4)).toStringAsFixed(1),
        'is_current_user': index == 12, // Current user at rank 13
      };
    });
  }

  String _getRankFromRating(int rating) {
    for (String rank in AppConstants.rankRanges.keys) {
      final range = AppConstants.rankRanges[rank]!;
      if (rating >= range[0] && rating <= range[1]) {
        return rank;
      }
    }
    return 'Champion';
  }
}