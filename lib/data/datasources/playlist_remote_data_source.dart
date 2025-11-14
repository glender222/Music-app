import 'package:harmonymusic/services/music_service.dart';
import 'package:harmonymusic/data/models/playlist_detail_model.dart';

abstract class PlaylistRemoteDataSource {
  Future<PlaylistDetailModel> getOnlinePlaylist(String playlistId);
}

class PlaylistRemoteDataSourceImpl implements PlaylistRemoteDataSource {
  final MusicServices musicServices;

  PlaylistRemoteDataSourceImpl({required this.musicServices});

  @override
  Future<PlaylistDetailModel> getOnlinePlaylist(String playlistId) async {
    final result = await musicServices.getPlaylistOrAlbumSongs(playlistId: playlistId);
    return PlaylistDetailModel.fromJson(result);
  }
}
