import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../models/annotation.dart';
import '../../controllers/song_controller.dart';
import '../widgets/annotation_widget.dart';

/// Écran de lecture de partition (PDF/MusicXML)
/// 
/// Permet de:
/// - Visualiser la partition
/// - Ajouter et modifier des annotations
/// - Naviguer entre les pages
/// - Zoomer et déplacer la vue
class ReaderScreen extends StatefulWidget {
  final Song song;

  const ReaderScreen({
    Key? key,
    required this.song,
  }) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late SongController _controller;
  int _currentPage = 0;
  final int _totalPages = 5; // TODO: Obtenir du document réel
  bool _showAnnotations = true;
  bool _isAnnotationMode = false;

  @override
  void initState() {
    super.initState();
    _controller = SongController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.song.title,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              widget.song.artist,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_showAnnotations ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showAnnotations = !_showAnnotations;
              });
            },
            tooltip: _showAnnotations ? 'Masquer les annotations' : 'Afficher les annotations',
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isAnnotationMode = !_isAnnotationMode;
              });
            },
            tooltip: 'Mode annotation',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showSongInfo,
            tooltip: 'Informations',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildReader(),
          ),
          _buildPageControls(),
        ],
      ),
      floatingActionButton: _isAnnotationMode
          ? FloatingActionButton(
              onPressed: _addAnnotation,
              child: const Icon(Icons.add_comment),
              tooltip: 'Ajouter une annotation',
            )
          : null,
    );
  }

  Widget _buildReader() {
    return Stack(
      children: [
        // Zone principale de lecture
        Center(
          child: Container(
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.song.fileType == 'pdf'
                      ? Icons.picture_as_pdf
                      : Icons.music_note,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.song.fileType == 'pdf'
                      ? 'Lecteur PDF'
                      : 'Lecteur MusicXML',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Page ${_currentPage + 1} / $_totalPages',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'TODO: Intégrer le lecteur PDF/MusicXML',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),

        // Annotations superposées
        if (_showAnnotations)
          Positioned.fill(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                final annotations = _controller
                    .getAnnotations(widget.song.id)
                    .where((a) => a.page == _currentPage)
                    .toList();

                return Stack(
                  children: annotations.map((annotation) {
                    return Positioned(
                      left: annotation.position['x'],
                      top: annotation.position['y'],
                      child: AnnotationWidget(
                        annotation: annotation,
                        isEditable: _isAnnotationMode,
                        onEdit: () => _editAnnotation(annotation),
                        onDelete: () => _deleteAnnotation(annotation),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPageControls() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: _currentPage > 0 ? _goToFirstPage : null,
            tooltip: 'Première page',
          ),
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: _currentPage > 0 ? _previousPage : null,
            tooltip: 'Page précédente',
          ),
          Text(
            'Page ${_currentPage + 1} / $_totalPages',
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: _currentPage < _totalPages - 1 ? _nextPage : null,
            tooltip: 'Page suivante',
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: _currentPage < _totalPages - 1 ? _goToLastPage : null,
            tooltip: 'Dernière page',
          ),
        ],
      ),
    );
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _goToFirstPage() {
    setState(() {
      _currentPage = 0;
    });
  }

  void _goToLastPage() {
    setState(() {
      _currentPage = _totalPages - 1;
    });
  }

  void _addAnnotation() {
    // Création d'une nouvelle annotation au centre de la page
    final annotation = Annotation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      songId: widget.song.id,
      page: _currentPage,
      type: 'text',
      content: 'Nouvelle annotation',
      position: {
        'x': 100.0,
        'y': 100.0,
        'width': 200.0,
        'height': 50.0,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _controller.addAnnotation(annotation);
    _editAnnotation(annotation);
  }

  void _editAnnotation(Annotation annotation) {
    showDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController(text: annotation.content);

        return AlertDialog(
          title: const Text('Modifier l\'annotation'),
          content: TextField(
            controller: textController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Entrez votre annotation...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                final updated = annotation.copyWith(
                  content: textController.text,
                  updatedAt: DateTime.now(),
                );
                _controller.updateAnnotation(updated);
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAnnotation(Annotation annotation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'annotation'),
        content: const Text('Voulez-vous vraiment supprimer cette annotation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _controller.deleteAnnotation(annotation.songId, annotation.id);
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showSongInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        children: [
          const Text(
            'Informations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Titre', widget.song.title),
          _buildInfoRow('Artiste', widget.song.artist),
          _buildInfoRow('Tonalité', widget.song.key),
          _buildInfoRow('Tempo', '${widget.song.tempo} BPM'),
          _buildInfoRow('Difficulté', widget.song.difficulty),
          _buildInfoRow('Format', widget.song.fileType.toUpperCase()),
          if (widget.song.tags.isNotEmpty)
            _buildInfoRow('Tags', widget.song.tags.join(', ')),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
