
class Track {
  final String name;
  final String artists;

  Track({required this.name, required this.artists});

  factory Track.fromJson(Map<String, dynamic> json) {
    final artistList = (json['artists'] as List)
        .map((a) => a['name'] as String)
        .join(', ');
    return Track(
      name: json['name'] ?? '',
      artists: artistList,
    );
  }
}
