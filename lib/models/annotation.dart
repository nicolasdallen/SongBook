class Annotation {
  final String id;
  final String songId;
  final int page;
  final String type; // text/drawing/ai
  final String content;
  final String position;
  final DateTime createdAt;
  final DateTime updatedAt;

  Annotation({
    required this.id,
    required this.songId,
    required this.page,
    required this.type,
    required this.content,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Annotation.fromJson(Map<String, dynamic> json) {
    return Annotation(
      id: json['id'],
      songId: json['songId'],
      page: json['page'],
      type: json['type'],
      content: json['content'],
      position: json['position'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'songId': songId,
      'page': page,
      'type': type,
      'content': content,
      'position': position,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}