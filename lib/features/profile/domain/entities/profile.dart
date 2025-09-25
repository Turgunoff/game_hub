import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String userId;
  final String displayName;
  final String? bio;
  final String? avatarUrl;
  final int gamesPlayed;
  final int gamesWon;
  final double winRate;
  final int level;
  final int experience;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.userId,
    required this.displayName,
    this.bio,
    this.avatarUrl,
    required this.gamesPlayed,
    required this.gamesWon,
    required this.winRate,
    required this.level,
    required this.experience,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        displayName,
        bio,
        avatarUrl,
        gamesPlayed,
        gamesWon,
        winRate,
        level,
        experience,
        createdAt,
        updatedAt,
      ];
}