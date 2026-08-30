class Game {
  final String id;
  final String name;
  final String imageUrl;
  final String genre;
  final String platform;
  final String description;
  double hoursPlayed;
  double rating; 

  Game({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genre,
    required this.platform,
    required this.description,
    required this.hoursPlayed,
    required this.rating,
  });
}