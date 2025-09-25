import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final String id;
  final String userId;
  final String gameType;
  final int currentRating;
  final int peakRating;
  final int gamesPlayed;
  final int wins;
  final int losses;
  final double winRate;
  final String rank;
  final int rankProgress;
  final DateTime lastGameAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Rating({
    required this.id,
    required this.userId,
    required this.gameType,
    required this.currentRating,
    required this.peakRating,
    required this.gamesPlayed,
    required this.wins,
    required this.losses,
    required this.winRate,
    required this.rank,
    required this.rankProgress,
    required this.lastGameAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        gameType,
        currentRating,
        peakRating,
        gamesPlayed,
        wins,
        losses,
        winRate,
        rank,
        rankProgress,
        lastGameAt,
        createdAt,
        updatedAt,
      ];
}