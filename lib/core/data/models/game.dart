import 'package:equatable/equatable.dart';

class Game extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final int playerCount;
  final bool isPopular;
  final List<String> features;
  final double rating;

  const Game({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.playerCount,
    required this.isPopular,
    required this.features,
    required this.rating,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        category,
        playerCount,
        isPopular,
        features,
        rating,
      ];
}