import 'package:harmonymusic/domain/playlist/entities/playlist_entity.dart';

abstract class PlaylistRepository {
  Future<void> savePlaylist(PlaylistEntity playlist);
  Future<void> removePlaylist(String playlistId);
}
