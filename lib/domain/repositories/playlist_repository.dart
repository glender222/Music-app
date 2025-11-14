import 'package:harmonymusic/domain/entities/playlist_detail_entity.dart';

abstract class PlaylistRepository {
  Future<PlaylistDetailEntity> getOnlinePlaylist(String playlistId);
}
