import 'package:flutter/material.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/library_screen.dart';
import 'ui/screens/reader_screen.dart';
import 'ui/screens/scene_mode_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'models/song.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SongBook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/library': (context) => const LibraryScreen(),
        '/scene-mode': (context) => const SceneModeScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/reader') {
          final song = settings.arguments as Song;
          return MaterialPageRoute(
            builder: (context) => ReaderScreen(song: song),
          );
        }
        return null;
      },
    );
  }
}