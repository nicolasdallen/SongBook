/// Modèle représentant une annotation sur une partition
/// 
/// Une annotation peut être un texte, un dessin ou un marqueur
/// placé sur une page spécifique d'une partition.
class Annotation {
  /// Identifiant unique de l'annotation
  final String id;
  
  /// Identifiant de la chanson associée
  final String songId;
  
  /// Numéro de page de la partition (commence à 0)
  final int page;
  
  /// Type d'annotation: 'text', 'drawing', 'marker'
  final String type;
  
  /// Contenu de l'annotation (texte ou données de dessin encodées)
  final String content;
  
  /// Position de l'annotation sur la page
  /// Format: {'x': double, 'y': double, 'width': double, 'height': double}
  final Map<String, double> position;
  
  /// Date de création de l'annotation
  final DateTime createdAt;
  
  /// Date de dernière modification
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

  /// Convertit l'annotation en JSON pour la persistence
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

  /// Crée une annotation à partir d'un JSON
  factory Annotation.fromJson(Map<String, dynamic> json) {
    return Annotation(
      id: json['id'] as String,
      songId: json['songId'] as String,
      page: json['page'] as int,
      type: json['type'] as String,
      content: json['content'] as String,
      position: Map<String, double>.from(json['position'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Crée une copie de l'annotation avec des modifications
  Annotation copyWith({
    String? id,
    String? songId,
    int? page,
    String? type,
    String? content,
    Map<String, double>? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Annotation(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      page: page ?? this.page,
      type: type ?? this.type,
      content: content ?? this.content,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Annotation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Annotation(id: $id, songId: $songId, page: $page, type: $type)';
}
