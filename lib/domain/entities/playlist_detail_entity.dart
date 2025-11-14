class PlaylistDetailEntity {
  final String id;
  final String title;
  final String? description;
  final String thumbnailUrl;
  final String? author;
  final String? year;
  final int? trackCount;
  final List<PlaylistSongEntity> tracks;

  PlaylistDetailEntity({
    required this.id,
    required this.title,
    this.description,
    required this.thumbnailUrl,
    this.author,
    this.year,
    this.trackCount,
    required this.tracks,
  });
}

class PlaylistSongEntity {
  final String id;
  final String title;
  final String? artist;
  final String? album;
  final String thumbnailUrl;
  final Duration? duration;

  PlaylistSongEntity({
    required this.id,
    required this.title,
    this.artist,
    this.album,
    required this.thumbnailUrl,
    this.duration,
  });
}
