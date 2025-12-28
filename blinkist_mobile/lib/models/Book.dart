class Book {
  final int id;
  final String title;
  final String author;
  final String imageUrl;
  final String audioUrl;
  final String summary;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.audioUrl,
    required this.summary,
  });

  // Фабрика для создания объекта из JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      author: json['author'] ?? 'Unknown Author',
      imageUrl: json['image_url'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      summary: json['summary'] ?? '',
    );
  }
}

