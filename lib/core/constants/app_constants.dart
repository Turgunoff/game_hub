class AppConstants {
  static const String appName = 'Game Hub';

  // Game types
  static const String pesMobile = 'PES Mobile 2026';
  static const String pubgMobile = 'PUBG Mobile';
  static const String freeFire = 'Free Fire';
  static const String codMobile = 'Call of Duty Mobile';
  static const String mobileLegends = 'Mobile Legends';
  static const String clashRoyale = 'Clash Royale';
  static const String brawlStars = 'Brawl Stars';
  static const String fortnite = 'Fortnite Mobile';

  static const List<String> gameTypes = [
    pesMobile,
    pubgMobile,
    freeFire,
    codMobile,
    mobileLegends,
    clashRoyale,
    brawlStars,
    fortnite,
  ];

  // Rating ranges
  static const Map<String, List<int>> rankRanges = {
    'Bronze': [0, 999],
    'Silver': [1000, 1499],
    'Gold': [1500, 1999],
    'Platinum': [2000, 2499],
    'Diamond': [2500, 2999],
    'Master': [3000, 3499],
    'Grandmaster': [3500, 3999],
    'Champion': [4000, 5000],
  };

  // Achievement types
  static const List<String> achievementTypes = [
    'First Victory',
    'Winning Streak',
    'Tournament Champion',
    'Challenge Master',
    'Rating Milestone',
    'Games Played',
    'Perfect Week',
    'Comeback King',
  ];
}