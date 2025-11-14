import 'package:harmonymusic/domain/entities/playlist_detail_entity.dart';
import 'package:audio_service/audio_service.dart';

class PlaylistDetailModel extends PlaylistDetailEntity {
  PlaylistDetailModel({
    required super.id,
    required super.title,
    super.description,
    required super.thumbnailUrl,
    super.author,
    super.year,
    super.trackCount,
    required List<PlaylistSongModel> tracks,
  }) : super(tracks: tracks);

  factory PlaylistDetailModel.fromJson(Map<String, dynamic> json) {
    return PlaylistDetailModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnailUrl: (json['thumbnails'] as List).isNotEmpty
          ? json['thumbnails'][0]['url']
          : '',
      author: json['author'] != null ? json['author']['name'] : null,
      year: json['year'],
      trackCount: json['trackCount'],
      tracks: (json['tracks'] as List? ?? [])
          .map((track) => PlaylistSongModel.fromMediaItem(track as MediaItem))
          .toList(),
    );
  }
}

class PlaylistSongModel extends PlaylistSongEntity {
  PlaylistSongModel({
    required super.id,
    required super.title,
    super.artist,
    super.album,
    required super.thumbnailUrl,
    super.duration,
  });

  factory PlaylistSongModel.fromMediaItem(MediaItem mediaItem) {
    return PlaylistSongModel(
      id: mediaItem.id,
      title: mediaItem.title,
      artist: mediaItem.artist,
      album: mediaItem.album,
      thumbnailUrl: mediaItem.artUri.toString(),
      duration: mediaItem.duration,
    );
  }
}
