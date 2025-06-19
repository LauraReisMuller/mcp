import 'package:flutter/material.dart';

class MusicSection extends StatelessWidget {
  const MusicSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Sleep Music',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: ListView(
            children: const [
              ListTile(
                leading: Icon(Icons.music_note),
                title: Text('Rain Sounds'),
                subtitle: Text('Gentle rain for relaxation'),
              ),
              ListTile(
                leading: Icon(Icons.music_note),
                title: Text('White Noise'),
                subtitle: Text('Classic white noise'),
              ),
              ListTile(
                leading: Icon(Icons.music_note),
                title: Text('Forest Ambience'),
                subtitle: Text('Nature sounds for deep sleep'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
