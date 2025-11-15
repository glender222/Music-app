import 'package:harmonymusic/domain/entities/search_result_entity.dart';
import 'package:harmonymusic/models/album.dart';
import 'package:harmonymusic/models/artist.dart';
import 'package:harmonymusic/models/playlist.dart';
import 'package:audio_service/audio_service.dart';

class SearchResultModel extends SearchResultEntity {
  SearchResultModel({
    required List<AlbumSummaryModel> albums,
    required List<ArtistSummaryModel> artists,
    required List<PlaylistSummaryModel> playlists,
    required List<SongModel> songs,
    required List<VideoModel> videos,
    Map<String, dynamic>? continuationParams,
  }) : super(
            albums: albums,
            artists: artists,
            playlists: playlists,
            songs: songs,
            videos: videos,
            continuationParams: continuationParams);

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      albums: (json['Albums'] as List? ?? [])
          .map((e) => AlbumSummaryModel.fromAlbum(e as Album))
          .toList(),
      artists: (json['Artists'] as List? ?? [])
          .map((e) => ArtistSummaryModel.fromArtist(e as Artist))
          .toList(),
      playlists: (json['Playlists'] as List? ?? [])
          .map((e) => PlaylistSummaryModel.fromPlaylist(e as Playlist))
          .toList(),
      songs: (json['Songs'] as List? ?? [])
          .map((e) => SongModel.fromMediaItem(e as MediaItem))
          .toList(),
      videos: (json['Videos'] as List? ?? [])
          .map((e) => VideoModel.fromMediaItem(e as MediaItem))
          .toList(),
      continuationParams: json['params'],
    );
  }
}

class AlbumSummaryModel extends AlbumSummaryEntity {
  AlbumSummaryModel({
    required super.browseId,
    required super.title,
    super.year,
    required super.thumbnailUrl,
    List<ArtistSummaryEntity>? artists,
  }) : super(artists: artists);

  factory AlbumSummaryModel.fromAlbum(Album album) {
    return AlbumSummaryModel(
      browseId: album.browseId,
      title: album.title,
      year: album.year,
      thumbnailUrl: album.thumbnailUrl,
      artists: album.artists?.map((artist) => ArtistSummaryModel.fromArtist(Artist.fromJson(artist))).toList(),
    );
  }
}

class ArtistSummaryModel extends ArtistSummaryEntity {
  ArtistSummaryModel({
    required super.browseId,
    required super.name,
    super.subscribers,
    required super.thumbnailUrl,
  });

  factory ArtistSummaryModel.fromArtist(Artist artist) {
    return ArtistSummaryModel(
      browseId: artist.browseId,
      name: artist.name,
      subscribers: artist.subscribers,
      thumbnailUrl: artist.thumbnailUrl,
    );
  }
}

class PlaylistSummaryModel extends PlaylistSummaryEntity {
  PlaylistSummaryModel({
    required super.browseId,
    required super.title,
    super.songCount,
    required super.thumbnailUrl,
  });

  factory PlaylistSummaryModel.fromPlaylist(Playlist playlist) {
    return PlaylistSummaryModel(
      browseId: playlist.playlistId,
      title: playlist.title,
      songCount: playlist.songCount,
      thumbnailUrl: playlist.thumbnailUrl,
    );
  }
}

class SongModel extends SongEntity {
  SongModel({
    required super.id,
    required super.title,
    required super.album,
    required super.artist,
    required super.thumbnailUrl,
    super.duration,
  });

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
    required super.id,
    required super.title,
    required super.author,
    required super.thumbnailUrl,
    super.views,
    super.length,
  });

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
