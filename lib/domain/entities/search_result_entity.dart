class SearchResultEntity {
  final List<AlbumEntity> albums;
  final List<ArtistEntity> artists;
  final List<PlaylistEntity> playlists;
  final List<SongEntity> songs;
  final List<VideoEntity> videos;

  SearchResultEntity({
    required this.albums,
    required this.artists,
    required this.playlists,
    required this.songs,
    required this.videos,
  });
}

class AlbumEntity {
  final String browseId;
  final String title;
  final String? year;
  final String thumbnailUrl;
  final List<ArtistEntity>? artists;

  AlbumEntity({
    required this.browseId,
    required this.title,
    this.year,
    required this.thumbnailUrl,
    this.artists,
  });
}

class ArtistEntity {
  final String browseId;
  final String name;
  final String? subscribers;
  final String thumbnailUrl;

  ArtistEntity({
    required this.browseId,
    required this.name,
    this.subscribers,
    required this.thumbnailUrl,
  });
}

class PlaylistEntity {
  final String browseId;
  final String title;
  final String? songCount;
  final String thumbnailUrl;

  PlaylistEntity({
    required this.browseId,
    required this.title,
    this.songCount,
    required this.thumbnailUrl,
  });
}

class SongEntity {
  final String id;
  final String title;
  final String album;
  final String artist;
  final String thumbnailUrl;
  final Duration? duration;

  SongEntity({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
    required this.thumbnailUrl,
    this.duration,
  });
}

class VideoEntity {
  final String id;
  final String title;
  final String author;
  final String thumbnailUrl;
  final String? views;
  final String? length;

  VideoEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    this.views,
    this.length,
  });
}
