import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class MetronomeService {
  int _bpm; // Beats per minute
  Timer _timer;
  AudioPlayer _audioPlayer;
  bool _isPlaying;

  MetronomeService({int bpm = 120}) : _bpm = bpm, _isPlaying = false {
    _audioPlayer = AudioPlayer();
  }

  void setBPM(int bpm) {
    _bpm = bpm;
    if (_isPlaying) {
      _start(); // Restart the metronome if it's currently playing
    }
  }

  void start() {
    _isPlaying = true;
    _start();
  }

  void stop() {
    _isPlaying = false;
    _timer?.cancel();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: (60000 / _bpm).round()), (timer) async {
      await _audioPlayer.play('assets/sounds/metronome_tick.mp3');
    });
  }

  void setSubdivisions(int subdivisions) {
    // This method can be implemented to manage subdivisions
    // For example, play additional sounds based on subdivisions
  }

  bool get isPlaying => _isPlaying;
  int get bpm => _bpm;
}