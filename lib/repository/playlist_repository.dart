// playlist_repository.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/track_model.dart';

class PlaylistRepository {
  final String baseUrl = 'http://192.168.1.10/MyAlbum/fetch_playlist.php';

  Future<List<Track>> fetchPlaylistTracks(String code) async {
    final uri = Uri.parse('$baseUrl?code=$code');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List;

      return items.map((item) {
        return Track.fromJson(item['track']);
      }).toList();
    } else {
      throw Exception('Failed to fetch playlist: ${response.body}');
    }
  }
}
