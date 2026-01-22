import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/song.dart';

/// Service pour gérer l'importation, la détection et le stockage des partitions
/// 
/// Ce service gère:
/// - L'importation de fichiers PDF et MusicXML
/// - La détection automatique du type de fichier
/// - Le stockage local des partitions
/// - La gestion des métadonnées
class FileService {
  /// Répertoire de stockage des partitions
  final String _storageDirectory;

  /// Formats de fichiers supportés
  static const List<String> supportedFormats = ['pdf', 'musicxml', 'xml', 'mxl'];

  FileService({String? storageDirectory})
      : _storageDirectory = storageDirectory ?? 'storage/songs';

  /// Importe une partition depuis un chemin de fichier
  /// 
  /// Détecte automatiquement le type de fichier et le copie dans le stockage
  /// Retourne un objet Song avec les métadonnées de base
  Future<Song> importSheet(String filePath) async {
    try {
      final file = File(filePath);
      
      if (!await file.exists()) {
        throw Exception('Le fichier n\'existe pas: $filePath');
      }

      // Détection du type de fichier
      final fileType = await detectFileType(filePath);
      
      if (!supportedFormats.contains(fileType.toLowerCase())) {
        throw Exception('Format de fichier non supporté: $fileType');
      }

      // Génération d'un ID unique
      final songId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Création du répertoire de stockage si nécessaire
      final storageDir = Directory(_storageDirectory);
      if (!await storageDir.exists()) {
        await storageDir.create(recursive: true);
      }

      // Copie du fichier dans le stockage
      final fileName = '${songId}_${file.uri.pathSegments.last}';
      final storagePath = '$_storageDirectory/$fileName';
      await file.copy(storagePath);

      // Extraction des métadonnées de base
      final metadata = await extractMetadata(storagePath, fileType);

      // Création de l'objet Song
      final song = Song(
        id: songId,
        title: metadata['title'] ?? 'Sans titre',
        artist: metadata['artist'] ?? 'Inconnu',
        tags: metadata['tags'] ?? [],
        key: metadata['key'] ?? 'C',
        tempo: metadata['tempo'] ?? 120,
        difficulty: metadata['difficulty'] ?? 'medium',
        fileType: fileType,
        filePath: storagePath,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      debugPrint('Partition importée avec succès: ${song.title}');
      return song;
    } catch (e) {
      debugPrint('Erreur lors de l\'importation: $e');
      rethrow;
    }
  }

  /// Détecte le type de fichier basé sur l'extension
  Future<String> detectFileType(String filePath) async {
    final extension = filePath.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return 'pdf';
      case 'xml':
      case 'musicxml':
      case 'mxl':
        return 'musicxml';
      default:
        return 'unknown';
    }
  }

  /// Extrait les métadonnées d'une partition
  /// 
  /// Pour les fichiers PDF, retourne des métadonnées minimales
  /// Pour les fichiers MusicXML, parse les informations de la partition
  Future<Map<String, dynamic>> extractMetadata(
    String filePath,
    String fileType,
  ) async {
    final metadata = <String, dynamic>{};

    try {
      if (fileType == 'musicxml') {
        // TODO: Implémenter le parsing MusicXML avec le package musicxml
        // Pour l'instant, retourne des métadonnées par défaut
        metadata['title'] = 'Partition MusicXML';
        metadata['artist'] = 'À définir';
        metadata['key'] = 'C';
        metadata['tempo'] = 120;
        metadata['difficulty'] = 'medium';
        metadata['tags'] = <String>[];
      } else if (fileType == 'pdf') {
        // TODO: Implémenter l'extraction de métadonnées PDF
        metadata['title'] = 'Partition PDF';
        metadata['artist'] = 'À définir';
        metadata['key'] = 'C';
        metadata['tempo'] = 120;
        metadata['difficulty'] = 'medium';
        metadata['tags'] = <String>[];
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'extraction des métadonnées: $e');
    }

    return metadata;
  }

  /// Supprime une partition du stockage
  Future<void> deleteSheet(Song song) async {
    try {
      final file = File(song.filePath);
      
      // Validation: vérifier que le fichier est dans le répertoire de stockage
      final storagePath = Directory(_storageDirectory).absolute.path;
      final filePath = file.absolute.path;
      
      if (!filePath.startsWith(storagePath)) {
        throw Exception('Tentative de suppression d\'un fichier en dehors du stockage');
      }
      
      if (await file.exists()) {
        await file.delete();
        debugPrint('Partition supprimée: ${song.title}');
      }
    } catch (e) {
      debugPrint('Erreur lors de la suppression: $e');
      rethrow;
    }
  }

  /// Liste toutes les partitions dans le répertoire de stockage
  Future<List<String>> listStoredSheets() async {
    try {
      final storageDir = Directory(_storageDirectory);
      
      if (!await storageDir.exists()) {
        return [];
      }

      final files = await storageDir.list().toList();
      return files
          .whereType<File>()
          .map((file) => file.path)
          .where((path) {
            final ext = path.split('.').last.toLowerCase();
            return supportedFormats.contains(ext);
          })
          .toList();
    } catch (e) {
      debugPrint('Erreur lors de la liste des partitions: $e');
      return [];
    }
  }

  /// Vérifie si un fichier existe dans le stockage
  Future<bool> exists(String filePath) async {
    final file = File(filePath);
    return file.exists();
  }

  /// Obtient la taille d'un fichier en octets
  Future<int> getFileSize(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }
}
