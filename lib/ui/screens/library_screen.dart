import 'package:flutter/material.dart';
import '../../controllers/song_controller.dart';
import '../widgets/song_card.dart';

/// Écran de bibliothèque avec recherche et filtrage avancé
/// 
/// Permet de:
/// - Rechercher des partitions par titre, artiste ou tags
/// - Filtrer par tonalité, difficulté
/// - Trier par différents critères
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late SongController _controller;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = SongController();
    _controller.loadSongs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliothèque'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
            tooltip: 'Trier',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
            tooltip: 'Filtrer',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildActiveFilters(),
          Expanded(child: _buildSongList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher par titre, artiste ou tag...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: ListenableBuilder(
            listenable: _searchController,
            builder: (context, child) {
              if (_searchController.text.isEmpty) return const SizedBox();
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _controller.clearSearch();
                },
              );
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) => _controller.setSearchQuery(value),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (!_controller.hasActiveFilters) return const SizedBox();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          height: 50,
          child: Row(
            children: [
              const Text('Filtres: '),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (_controller.filterKey != null)
                      _buildFilterChip(
                        'Tonalité: ${_controller.filterKey}',
                        () => _controller.filterByKey(null),
                      ),
                    if (_controller.filterDifficulty != null)
                      _buildFilterChip(
                        'Difficulté: ${_controller.filterDifficulty}',
                        () => _controller.filterByDifficulty(null),
                      ),
                    for (final tag in _controller.filterTags)
                      _buildFilterChip(
                        tag,
                        () {
                          final tags = List<String>.from(_controller.filterTags);
                          tags.remove(tag);
                          _controller.filterByTags(tags);
                        },
                      ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _controller.clearFilters,
                child: const Text('Effacer tout'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onRemove,
      ),
    );
  }

  Widget _buildSongList() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final songs = _controller.songs;

        if (songs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.music_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  _controller.hasActiveFilters || _controller.searchQuery.isNotEmpty
                      ? 'Aucune partition trouvée'
                      : 'Aucune partition dans la bibliothèque',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return SongCard(
              song: songs[index],
              onTap: () => _openReader(songs[index]),
              onLongPress: () => _showSongOptions(songs[index]),
            );
          },
        );
      },
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Trier par',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.title),
            title: const Text('Titre (A-Z)'),
            onTap: () {
              _controller.sortByTitle(ascending: true);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.title),
            title: const Text('Titre (Z-A)'),
            onTap: () {
              _controller.sortByTitle(ascending: false);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Artiste (A-Z)'),
            onTap: () {
              _controller.sortByArtist(ascending: true);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Date d\'ajout (récent)'),
            onTap: () {
              _controller.sortByCreatedDate(ascending: false);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Difficulté (croissant)'),
            onTap: () {
              _controller.sortByDifficulty(ascending: true);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                'Filtrer par',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildKeyFilter(),
              const SizedBox(height: 16),
              _buildDifficultyFilter(),
              const SizedBox(height: 16),
              _buildTagFilter(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKeyFilter() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final keys = _controller.availableKeys;
        if (keys.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tonalité', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: keys.map((key) {
                final isSelected = _controller.filterKey == key;
                return FilterChip(
                  label: Text(key),
                  selected: isSelected,
                  onSelected: (selected) {
                    _controller.filterByKey(selected ? key : null);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDifficultyFilter() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final difficulties = ['easy', 'medium', 'hard'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Difficulté', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: difficulties.map((difficulty) {
                final isSelected = _controller.filterDifficulty == difficulty;
                return FilterChip(
                  label: Text(difficulty),
                  selected: isSelected,
                  onSelected: (selected) {
                    _controller.filterByDifficulty(selected ? difficulty : null);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTagFilter() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final tags = _controller.availableTags;
        if (tags.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: tags.map((tag) {
                final isSelected = _controller.filterTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    final currentTags = List<String>.from(_controller.filterTags);
                    if (selected) {
                      currentTags.add(tag);
                    } else {
                      currentTags.remove(tag);
                    }
                    _controller.filterByTags(currentTags);
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  void _showSongOptions(song) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Modifier'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implémenter l'édition
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Supprimer'),
            onTap: () async {
              Navigator.pop(context);
              final confirm = await _confirmDelete();
              if (confirm) {
                await _controller.deleteSong(song.id);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmer la suppression'),
            content: const Text('Voulez-vous vraiment supprimer cette partition ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Supprimer'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _openReader(song) {
    Navigator.pushNamed(
      context,
      '/reader',
      arguments: song,
    );
  }
}
