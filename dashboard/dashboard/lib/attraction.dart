class Attraction {
  final String name;
  final String photoUrl;
  final int waitTime;
  final bool isAvailable;
  final String secteur; 
  bool isFavorite;

  Attraction({
    required this.name,
    required this.photoUrl,
    required this.waitTime,
    required this.isAvailable,
    required this.secteur, 
    this.isFavorite = false,
  });
}