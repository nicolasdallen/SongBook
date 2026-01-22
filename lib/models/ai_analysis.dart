/// Modèle représentant une analyse IA d'une partition
/// 
/// Contient les informations extraites automatiquement par l'IA:
/// tonalité, accords, structure, et suggestions d'amélioration.
class AIAnalysis {
  /// Identifiant de la chanson analysée
  final String songId;
  
  /// Tonalité détectée de la chanson (ex: 'C', 'Am', 'F#m')
  final String key;
  
  /// Liste des accords détectés dans la partition
  /// Format: ['C', 'G', 'Am', 'F']
  final List<String> chords;
  
  /// Structure de la chanson
  /// Format: {'intro': [0, 4], 'verse': [4, 12], 'chorus': [12, 20]}
  /// Les valeurs représentent les mesures de début et fin
  final Map<String, List<int>> structure;
  
  /// Suggestions générées par l'IA
  /// Format: [{'type': 'tempo', 'suggestion': 'Augmenter le tempo à 120 BPM'}]
  final List<Map<String, String>> suggestions;
  
  /// Score de confiance de l'analyse (0.0 à 1.0)
  final double confidence;
  
  /// Date de l'analyse
  final DateTime analyzedAt;
  
  /// Version du modèle IA utilisé
  final String modelVersion;

  AIAnalysis({
    required this.songId,
    required this.key,
    required this.chords,
    required this.structure,
    required this.suggestions,
    required this.confidence,
    required this.analyzedAt,
    required this.modelVersion,
  });

  /// Convertit l'analyse en JSON pour la persistence
  Map<String, dynamic> toJson() {
    return {
      'songId': songId,
      'key': key,
      'chords': chords,
      'structure': structure,
      'suggestions': suggestions,
      'confidence': confidence,
      'analyzedAt': analyzedAt.toIso8601String(),
      'modelVersion': modelVersion,
    };
  }

  /// Crée une analyse à partir d'un JSON
  factory AIAnalysis.fromJson(Map<String, dynamic> json) {
    return AIAnalysis(
      songId: json['songId'] as String,
      key: json['key'] as String,
      chords: List<String>.from(json['chords'] as List),
      structure: (json['structure'] as Map).map(
        (key, value) => MapEntry(
          key as String,
          List<int>.from(value as List),
        ),
      ),
      suggestions: (json['suggestions'] as List)
          .map((item) => Map<String, String>.from(item as Map))
          .toList(),
      confidence: (json['confidence'] as num).toDouble(),
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
      modelVersion: json['modelVersion'] as String,
    );
  }

  /// Crée une copie de l'analyse avec des modifications
  AIAnalysis copyWith({
    String? songId,
    String? key,
    List<String>? chords,
    Map<String, List<int>>? structure,
    List<Map<String, String>>? suggestions,
    double? confidence,
    DateTime? analyzedAt,
    String? modelVersion,
  }) {
    return AIAnalysis(
      songId: songId ?? this.songId,
      key: key ?? this.key,
      chords: chords ?? this.chords,
      structure: structure ?? this.structure,
      suggestions: suggestions ?? this.suggestions,
      confidence: confidence ?? this.confidence,
      analyzedAt: analyzedAt ?? this.analyzedAt,
      modelVersion: modelVersion ?? this.modelVersion,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIAnalysis &&
          runtimeType == other.runtimeType &&
          songId == other.songId &&
          analyzedAt == other.analyzedAt;

  @override
  int get hashCode => songId.hashCode ^ analyzedAt.hashCode;

  @override
  String toString() => 'AIAnalysis(songId: $songId, key: $key, confidence: $confidence)';
}
