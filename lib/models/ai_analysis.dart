class AIAnalysis {
  String songId;
  String key;
  List<String> chords;
  String structure;
  List<String> suggestions;
  DateTime analyzedAt;

  AIAnalysis({
    required this.songId,
    required this.key,
    required this.chords,
    required this.structure,
    required this.suggestions,
    required this.analyzedAt,
  });

  factory AIAnalysis.fromJson(Map<String, dynamic> json) {
    return AIAnalysis(
      songId: json['songId'],
      key: json['key'],
      chords: List<String>.from(json['chords']),
      structure: json['structure'],
      suggestions: List<String>.from(json['suggestions']),
      analyzedAt: DateTime.parse(json['analyzedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'songId': songId,
      'key': key,
      'chords': chords,
      'structure': structure,
      'suggestions': suggestions,
      'analyzedAt': analyzedAt.toIso8601String(),
    };
  }
}