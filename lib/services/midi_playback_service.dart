class MidiPlaybackService {
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  int _currentPosition = 0;
  int _totalDuration = 0;

  Future<void> playMidi(String midiFilePath) async {
    try {
      _isPlaying = true;
    } catch (e) {
      print('Error playing MIDI: $e');
      _isPlaying = false;
    }
  }

  Future<void> stop() async {
    try {
      _isPlaying = false;
      _currentPosition = 0;
    } catch (e) {
      print('Error stopping MIDI: $e');
    }
  }

  Future<void> pause() async {
    try {
      _isPlaying = false;
    } catch (e) {
      print('Error pausing MIDI: $e');
    }
  }

  Future<void> resume() async {
    try {
      _isPlaying = true;
    } catch (e) {
      print('Error resuming MIDI: $e');
    }
  }

  void setPlaybackSpeed(double speed) {
    _playbackSpeed = speed;
  }

  Future<void> seek(int positionMs) async {
    try {
      _currentPosition = positionMs;
    } catch (e) {
      print('Error seeking MIDI: $e');
    }
  }

  int getCurrentPosition() {
    return _currentPosition;
  }

  int getTotalDuration() {
    return _totalDuration;
  }

  bool get isPlaying => _isPlaying;
  double get playbackSpeed => _playbackSpeed;
}