import 'package:flutter/material.dart';

class SongDetailScreen extends StatelessWidget {
  final String songId;
  const SongDetailScreen({required this.songId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Details'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Song Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Artist Name', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(height: 16),
                    Text('Key: C Major'),
                    Text('Tempo: 120 BPM'),
                    Text('Difficulty: 5'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Annotations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Annotation 1'),
                subtitle: const Text('Page 1'),
              ),
            ),
            const SizedBox(height: 24),
            const Text('AI Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Chords: C, G, Am, F'),
                    SizedBox(height: 8),
                    Text('Structure: Verse, Chorus, Bridge'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
