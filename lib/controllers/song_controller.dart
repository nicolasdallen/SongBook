import 'package:flutter/foundation.dart';
import '../models/song.dart';
import '../models/annotation.dart';
import '../services/file_service.dart';

/// Contrôleur pour gérer la collection de partitions
/// 
/// Gère:
/// - La liste des partitions
/// - La recherche et le filtrage
/// - Les annotations
/// - Le tri par différents critères
class SongController extends ChangeNotifier {
  /// Service de gestion de fichiers
  final FileService _fileService;

  /// Liste de toutes les partitions
  List<Song> _songs = [];

  /// Liste des annotations
  final Map<String, List<Annotation>> _annotations = {};

  /// Partition actuellement sélectionnée
  Song? _selectedSong;

  /// Termes de recherche actuels
  String _searchQuery = '';

  /// Filtres actifs
  String? _filterKey;
  String? _filterDifficulty;
  List<String> _filterTags = [];

  /// État de chargement
  bool _isLoading = false;

  SongController({FileService? fileService})
      : _fileService = fileService ?? FileService();

  /// Obtient la liste des partitions (filtrée si nécessaire)
  List<Song> get songs {
    var filtered = List<Song>.from(_songs);

    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((song) {
        return song.title.toLowerCase().contains(query) ||
            song.artist.toLowerCase().contains(query) ||
            song.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    // Filtre par tonalité
    if (_filterKey != null) {
      filtered = filtered.where((song) => song.key == _filterKey).toList();
    }

    // Filtre par difficulté
    if (_filterDifficulty != null) {
      filtered = filtered
          .where((song) => song.difficulty == _filterDifficulty)
          .toList();
    }

    // Filtre par tags
    if (_filterTags.isNotEmpty) {
      filtered = filtered.where((song) {
        return _filterTags.every((tag) => song.tags.contains(tag));
      }).toList();
    }

    return filtered;
  }

  /// Obtient toutes les partitions sans filtre
  List<Song> get allSongs => List<Song>.from(_songs);

  /// Obtient la partition sélectionnée
  Song? get selectedSong => _selectedSong;

  /// Obtient l'état de chargement
  bool get isLoading => _isLoading;

  /// Obtient la requête de recherche actuelle
  String get searchQuery => _searchQuery;

  /// Obtient les filtres actifs
  String? get filterKey => _filterKey;
  String? get filterDifficulty => _filterDifficulty;
  List<String> get filterTags => List<String>.from(_filterTags);

  /// Charge toutes les partitions
  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Charger depuis une base de données ou un stockage local
      // Pour l'instant, utilise une liste vide
      _songs = [];
      debugPrint('Partitions chargées: ${_songs.length}');
    } catch (e) {
      debugPrint('Erreur lors du chargement des partitions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ajoute une partition à la collection
  Future<void> addSong(Song song) async {
    _songs.add(song);
    notifyListeners();
    debugPrint('Partition ajoutée: ${song.title}');
  }

  /// Importe une partition depuis un fichier
  Future<Song> importSong(String filePath) async {
    _isLoading = true;
    notifyListeners();

    try {
      final song = await _fileService.importSheet(filePath);
      await addSong(song);
      return song;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Supprime une partition de la collection
  Future<void> deleteSong(String songId) async {
    final song = _songs.firstWhere((s) => s.id == songId);
    
    // Supprime le fichier
    await _fileService.deleteSheet(song);
    
    // Supprime de la liste
    _songs.removeWhere((s) => s.id == songId);
    
    // Supprime les annotations associées
    _annotations.remove(songId);
    
    // Désélectionne si c'était la partition sélectionnée
    if (_selectedSong?.id == songId) {
      _selectedSong = null;
    }
    
    notifyListeners();
    debugPrint('Partition supprimée: ${song.title}');
  }

  /// Met à jour une partition
  void updateSong(Song song) {
    final index = _songs.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      _songs[index] = song;
      
      // Met à jour la partition sélectionnée si nécessaire
      if (_selectedSong?.id == song.id) {
        _selectedSong = song;
      }
      
      notifyListeners();
      debugPrint('Partition mise à jour: ${song.title}');
    }
  }

  /// Sélectionne une partition
  void selectSong(Song song) {
    _selectedSong = song;
    notifyListeners();
  }

  /// Désélectionne la partition actuelle
  void deselectSong() {
    _selectedSong = null;
    notifyListeners();
  }

  /// Définit la requête de recherche
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Efface la recherche
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Filtre par tonalité
  void filterByKey(String? key) {
    _filterKey = key;
    notifyListeners();
  }

  /// Filtre par difficulté
  void filterByDifficulty(String? difficulty) {
    _filterDifficulty = difficulty;
    notifyListeners();
  }

  /// Filtre par tags
  void filterByTags(List<String> tags) {
    _filterTags = tags;
    notifyListeners();
  }

  /// Efface tous les filtres
  void clearFilters() {
    _filterKey = null;
    _filterDifficulty = null;
    _filterTags = [];
    notifyListeners();
  }

  /// Vérifie si des filtres sont actifs
  bool get hasActiveFilters =>
      _filterKey != null ||
      _filterDifficulty != null ||
      _filterTags.isNotEmpty;

  /// Tri les partitions par titre
  void sortByTitle({bool ascending = true}) {
    _songs.sort((a, b) {
      final comparison = a.title.compareTo(b.title);
      return ascending ? comparison : -comparison;
    });
    notifyListeners();
  }

  /// Tri les partitions par artiste
  void sortByArtist({bool ascending = true}) {
    _songs.sort((a, b) {
      final comparison = a.artist.compareTo(b.artist);
      return ascending ? comparison : -comparison;
    });
    notifyListeners();
  }

  /// Tri les partitions par date de création
  void sortByCreatedDate({bool ascending = true}) {
    _songs.sort((a, b) {
      final comparison = a.createdAt.compareTo(b.createdAt);
      return ascending ? comparison : -comparison;
    });
    notifyListeners();
  }

  /// Tri les partitions par difficulté
  void sortByDifficulty({bool ascending = true}) {
    final difficultyOrder = {'easy': 1, 'medium': 2, 'hard': 3};
    _songs.sort((a, b) {
      final aValue = difficultyOrder[a.difficulty] ?? 2;
      final bValue = difficultyOrder[b.difficulty] ?? 2;
      final comparison = aValue.compareTo(bValue);
      return ascending ? comparison : -comparison;
    });
    notifyListeners();
  }

  /// Obtient les partitions récentes (dernières 10)
  List<Song> get recentSongs {
    final sorted = List<Song>.from(_songs);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(10).toList();
  }

  /// Obtient les tonalités uniques de toutes les partitions
  List<String> get availableKeys {
    final keys = _songs.map((song) => song.key).toSet().toList();
    keys.sort();
    return keys;
  }

  /// Obtient les difficultés uniques de toutes les partitions
  List<String> get availableDifficulties {
    return _songs.map((song) => song.difficulty).toSet().toList();
  }

  /// Obtient tous les tags uniques
  List<String> get availableTags {
    final allTags = <String>{};
    for (final song in _songs) {
      allTags.addAll(song.tags);
    }
    final tags = allTags.toList();
    tags.sort();
    return tags;
  }

  /// Ajoute une annotation à une partition
  void addAnnotation(Annotation annotation) {
    if (!_annotations.containsKey(annotation.songId)) {
      _annotations[annotation.songId] = [];
    }
    _annotations[annotation.songId]!.add(annotation);
    notifyListeners();
  }

  /// Obtient les annotations d'une partition
  List<Annotation> getAnnotations(String songId) {
    return _annotations[songId] ?? [];
  }

  /// Met à jour une annotation
  void updateAnnotation(Annotation annotation) {
    final annotations = _annotations[annotation.songId];
    if (annotations != null) {
      final index = annotations.indexWhere((a) => a.id == annotation.id);
      if (index != -1) {
        annotations[index] = annotation;
        notifyListeners();
      }
    }
  }

  /// Supprime une annotation
  void deleteAnnotation(String songId, String annotationId) {
    final annotations = _annotations[songId];
    if (annotations != null) {
      annotations.removeWhere((a) => a.id == annotationId);
      notifyListeners();
    }
  }
}
