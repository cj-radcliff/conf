class Session {
  final String id;
  final String title;
  final String speaker;
  final DateTime startTime;
  final DateTime endTime;
  final String room;
  final String track;
  final String description;
  final String imageUrl;
  final bool isKeynote;
  final bool isFavorite;

  Session({
    required this.id,
    required this.title,
    required this.speaker,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.track,
    required this.description,
    this.imageUrl = '',
    this.isKeynote = false,
    this.isFavorite = false,
  });
}
