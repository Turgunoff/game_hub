import 'package:equatable/equatable.dart';

enum TournamentStatus { upcoming, ongoing, completed, cancelled }

enum TournamentFormat { singleElimination, doubleElimination, roundRobin, swiss }

class Tournament extends Equatable {
  final String id;
  final String name;
  final String description;
  final String gameType;
  final TournamentFormat format;
  final int maxParticipants;
  final int currentParticipants;
  final double entryFee;
  final double prizePool;
  final TournamentStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registrationDeadline;
  final String? imageUrl;
  final List<String> rules;
  final List<String> participants;
  final DateTime createdAt;

  const Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.gameType,
    required this.format,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.entryFee,
    required this.prizePool,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.registrationDeadline,
    this.imageUrl,
    required this.rules,
    required this.participants,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        gameType,
        format,
        maxParticipants,
        currentParticipants,
        entryFee,
        prizePool,
        status,
        startDate,
        endDate,
        registrationDeadline,
        imageUrl,
        rules,
        participants,
        createdAt,
      ];
}