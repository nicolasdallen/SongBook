import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/song.dart';
import '../../controllers/song_controller.dart';
import '../widgets/song_card.dart';

/// Mode scène optimisé pour la performance live
/// 
/// Fonctionnalités:
/// - Affichage plein écran
/// - Navigation simplifiée entre les partitions
/// - Écran toujours actif
/// - Contrôles minimaux pour ne pas distraire
/// - Liste de lecture (setlist)
class SceneModeScreen extends StatefulWidget {
  const SceneModeScreen({Key? key}) : super(key: key);

  @override
  State<SceneModeScreen> createState() => _SceneModeScreenState();
}

class _SceneModeScreenState extends State<SceneModeScreen> {
  late SongController _controller;
  List<Song> _setlist = [];
  int _currentIndex = 0;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _controller = SongController();
    _controller.loadSongs();
    _enableKeepScreenOn();
  }

  @override
  void dispose() {
    _disableKeepScreenOn();
    _controller.dispose();
    super.dispose();
  }

  void _enableKeepScreenOn() {
    // TODO: Implémenter avec wakelock package
    try {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (e) {
      debugPrint('Erreur lors de l\'activation du mode plein écran: $e');
    }
  }

  void _disableKeepScreenOn() {
    try {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } catch (e) {
      debugPrint('Erreur lors de la désactivation du mode plein écran: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_setlist.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mode Scène'),
        ),
        body: _buildSetlistSetup(),
      );
    }

    if (_isFullscreen) {
      return _buildFullscreenReader();
    }

    return _buildSetlistView();
  }

  Widget _buildSetlistSetup() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Créer une setlist',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sélectionnez les partitions pour votre performance',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              if (_setlist.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_setlist.length} partition(s) sélectionnée(s)',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: _startPerformance,
                          child: const Text('Démarrer'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              final songs = _controller.allSongs;

              if (songs.isEmpty) {
                return const Center(
                  child: Text('Aucune partition disponible'),
                );
              }

              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final isSelected = _setlist.contains(song);

                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _setlist.add(song);
                        } else {
                          _setlist.remove(song);
                        }
                      });
                    },
                    title: Text(song.title),
                    subtitle: Text(song.artist),
                    secondary: const Icon(Icons.music_note),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSetlistView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mode Scène'),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: _toggleFullscreen,
            tooltip: 'Plein écran',
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _exitSceneMode,
            tooltip: 'Quitter',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView.builder(
              itemCount: _setlist.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: _setlist.map((song) {
                return _buildSongPage(song);
              }).toList(),
            ),
          ),
          _buildNavigationControls(),
        ],
      ),
    );
  }

  Widget _buildFullscreenReader() {
    final song = _setlist[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isFullscreen = false;
          });
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity > 0) {
            _previousSong();
          } else if (details.primaryVelocity < 0) {
            _nextSong();
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                song.fileType == 'pdf' ? Icons.picture_as_pdf : Icons.music_note,
                size: 100,
                color: Colors.white54,
              ),
              const SizedBox(height: 24),
              Text(
                song.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                song.artist,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Partition ${_currentIndex + 1} / ${_setlist.length}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Touchez pour quitter le mode plein écran',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: (_currentIndex + 1) / _setlist.length,
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildSongPage(Song song) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            song.fileType == 'pdf' ? Icons.picture_as_pdf : Icons.music_note,
            size: 120,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            song.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            song.artist,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          Chip(
            label: Text('${song.key} - ${song.tempo} BPM'),
          ),
          const SizedBox(height: 16),
          const Text(
            'TODO: Afficher la partition',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous, size: 32),
            onPressed: _currentIndex > 0 ? _previousSong : null,
            tooltip: 'Précédent',
          ),
          Text(
            '${_currentIndex + 1} / ${_setlist.length}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, size: 32),
            onPressed: _currentIndex < _setlist.length - 1 ? _nextSong : null,
            tooltip: 'Suivant',
          ),
        ],
      ),
    );
  }

  void _startPerformance() {
    setState(() {
      _currentIndex = 0;
    });
  }

  void _previousSong() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _nextSong() {
    if (_currentIndex < _setlist.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  void _exitSceneMode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter le mode scène'),
        content: const Text('Voulez-vous vraiment quitter le mode scène ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
  }
}
