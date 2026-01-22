class SongController {
  List<dynamic> _songs = [];

  List<dynamic> getSongs() {
    return _songs;
  }

  void addSong(dynamic song) {
    _songs.add(song);
  }

  void removeSong(String id) {
    _songs.removeWhere((song) => song.id == id);
  }

  void updateSong(dynamic song) {
    final index = _songs.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      _songs[index] = song;
    }
  }

  List<dynamic> searchSongs(String query) {
    return _songs.where((song) => song.title.toLowerCase().contains(query.toLowerCase()) || song.artist.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<dynamic> filterByTag(String tag) {
    return _songs.where((song) => song.tags.contains(tag)).toList();
  }

  List<String> getAllTags() {
    final tags = <String>{};
    for (var song in _songs) {
      tags.addAll(song.tags);
    }
    return tags.toList();
  }

  void sortByTitle() {
    _songs.sort((a, b) => a.title.compareTo(b.title));
  }

  void sortByArtist() {
    _songs.sort((a, b) => a.artist.compareTo(b.artist));
  }

  void sortByDifficulty() {
    _songs.sort((a, b) => a.difficulty.compareTo(b.difficulty));
  }
}