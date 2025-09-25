import 'package:equatable/equatable.dart';

enum ChallengeStatus { pending, accepted, ongoing, completed, rejected, cancelled }

enum ChallengeType { oneVsOne, team, public }

class Challenge extends Equatable {
  final String id;
  final String challengerId;
  final String? challengedUserId;
  final String gameType;
  final ChallengeType type;
  final ChallengeStatus status;
  final double? wager;
  final String? description;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final String? winnerId;
  final Map<String, dynamic>? gameSettings;

  const Challenge({
    required this.id,
    required this.challengerId,
    this.challengedUserId,
    required this.gameType,
    required this.type,
    required this.status,
    this.wager,
    this.description,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
    this.winnerId,
    this.gameSettings,
  });

  @override
  List<Object?> get props => [
        id,
        challengerId,
        challengedUserId,
        gameType,
        type,
        status,
        wager,
        description,
        createdAt,
        acceptedAt,
        completedAt,
        winnerId,
        gameSettings,
      ];
}