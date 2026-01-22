class Song {
  final String id;
  final String title;
  final String artist;
  final List<String> tags;
  final String key;
  final int tempo;
  final String difficulty;
  final String fileType;
  final String filePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.tags,
    required this.key,
    required this.tempo,
    required this.difficulty,
    required this.fileType,
    required this.filePath,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'tags': tags,
      'key': key,
      'tempo': tempo,
      'difficulty': difficulty,
      'fileType': fileType,
      'filePath': filePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      tags: List<String>.from(json['tags']),
      key: json['key'],
      tempo: json['tempo'],
      difficulty: json['difficulty'],
      fileType: json['fileType'],
      filePath: json['filePath'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
