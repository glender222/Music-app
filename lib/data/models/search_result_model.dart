import 'package:harmonymusic/domain/entities/search_result_entity.dart';
import 'package:harmonymusic/models/album.dart';
import 'package:harmonymusic/models/artist.dart';
import 'package:harmonymusic/models/playlist.dart';
import 'package:audio_service/audio_service.dart';

class SearchResultModel extends SearchResultEntity {
  SearchResultModel({
    required List<AlbumModel> albums,
    required List<ArtistModel> artists,
    required List<PlaylistModel> playlists,
    required List<SongModel> songs,
    required List<VideoModel> videos,
  }) : super(
            albums: albums,
            artists: artists,
            playlists: playlists,
            songs: songs,
            videos: videos);

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      albums: (json['Albums'] as List? ?? [])
          .map((e) => AlbumModel.fromAlbum(e as Album))
          .toList(),
      artists: (json['Artists'] as List? ?? [])
          .map((e) => ArtistModel.fromArtist(e as Artist))
          .toList(),
      playlists: (json['Playlists'] as List? ?? [])
          .map((e) => PlaylistModel.fromPlaylist(e as Playlist))
          .toList(),
      songs: (json['Songs'] as List? ?? [])
          .map((e) => SongModel.fromMediaItem(e as MediaItem))
          .toList(),
      videos: (json['Videos'] as List? ?? [])
          .map((e) => VideoModel.fromMediaItem(e as MediaItem))
          .toList(),
    );
  }
}

class AlbumModel extends AlbumEntity {
  AlbumModel({
    required String browseId,
    required String title,
    String? year,
    required String thumbnailUrl,
  }) : super(
            browseId: browseId,
            title: title,
            year: year,
            thumbnailUrl: thumbnailUrl);

  factory AlbumModel.fromAlbum(Album album) {
    return AlbumModel(
      browseId: album.browseId,
      title: album.title,
      year: album.year,
      thumbnailUrl: album.thumbnailUrl,
    );
  }
}

class ArtistModel extends ArtistEntity {
  ArtistModel({
    required String browseId,
    required String name,
    String? subscribers,
    required String thumbnailUrl,
  }) : super(
            browseId: browseId,
            name: name,
            subscribers: subscribers,
            thumbnailUrl: thumbnailUrl);

  factory ArtistModel.fromArtist(Artist artist) {
    return ArtistModel(
      browseId: artist.browseId,
      name: artist.name,
      subscribers: artist.subscribers,
      thumbnailUrl: artist.thumbnailUrl,
    );
  }
}

class PlaylistModel extends PlaylistEntity {
  PlaylistModel({
    required String browseId,
    required String title,
    String? songCount,
    required String thumbnailUrl,
  }) : super(
            browseId: browseId,
            title: title,
            songCount: songCount,
            thumbnailUrl: thumbnailUrl);

  factory PlaylistModel.fromPlaylist(Playlist playlist) {
    return PlaylistModel(
      browseId: playlist.playlistId,
      title: playlist.title,
      songCount: playlist.songCount,
      thumbnailUrl: playlist.thumbnailUrl,
    );
  }
}

class SongModel extends SongEntity {
  SongModel({
    required String id,
    required String title,
    required String album,
    required String artist,
    required String thumbnailUrl,
    Duration? duration,
  }) : super(
            id: id,
            title: title,
            album: album,
            artist: artist,
            thumbnailUrl: thumbnailUrl,
            duration: duration);

  factory SongModel.fromMediaItem(MediaItem mediaItem) {
    return SongModel(
      id: mediaItem.id,
      title: mediaItem.title,
      album: mediaItem.album ?? '',
      artist: mediaItem.artist ?? '',
      thumbnailUrl: mediaItem.artUri.toString(),
      duration: mediaItem.duration,
    );
  }
}

class VideoModel extends VideoEntity {
  VideoModel({
    required String id,
    required String title,
    required String author,
    required String thumbnailUrl,
    String? views,
    String? length,
  }) : super(
            id: id,
            title: title,
            author: author,
            thumbnailUrl: thumbnailUrl,
            views: views,
            length: length);

  factory VideoModel.fromMediaItem(MediaItem mediaItem) {
    return VideoModel(
      id: mediaItem.id,
      title: mediaItem.title,
      author: mediaItem.artist ?? '',
      thumbnailUrl: mediaItem.artUri.toString(),
      views: mediaItem.extras?['views'],
      length: mediaItem.extras?['length'],
    );
  }
}
