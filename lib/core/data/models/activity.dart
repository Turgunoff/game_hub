import 'package:equatable/equatable.dart';

enum ActivityType { game, tournament, challenge, achievement, rating }

class Activity extends Equatable {
  final String id;
  final ActivityType type;
  final String title;
  final String description;
  final String? gameType;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const Activity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.gameType,
    required this.timestamp,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        gameType,
        timestamp,
        metadata,
      ];
}