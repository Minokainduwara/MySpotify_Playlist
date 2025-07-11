
import 'package:flutter/material.dart';
import '../models/track_model.dart';

class TrackTile extends StatelessWidget {
  final Track track;

  const TrackTile({required this.track});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(track.name),
      subtitle: Text(track.artists),
    );
  }
}
