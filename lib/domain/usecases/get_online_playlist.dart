import 'package:harmonymusic/domain/entities/playlist_detail_entity.dart';
import 'package:harmonymusic/domain/repositories/playlist_repository.dart';

class GetOnlinePlaylist {
  final PlaylistRepository repository;

  GetOnlinePlaylist(this.repository);

  Future<PlaylistDetailEntity> call(String playlistId) {
    return repository.getOnlinePlaylist(playlistId);
  }
}
