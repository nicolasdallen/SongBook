import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  final String songTitle;
  final List<String> detectedChords;
  final String songStructure;

  AnalysisScreen({required this.songTitle, required this.detectedChords, required this.songStructure});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis of $songTitle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[  
            Text('Detected Chords:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...detectedChords.map((chord) => Text(chord)).toList(),
            SizedBox(height: 20),
            Text('Song Structure:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(songStructure),
          ],
        ),
      ),
    );
  }
}