import 'package:harmonymusic/domain/entities/playlist_detail_entity.dart';
import 'package:harmonymusic/domain/repositories/playlist_repository.dart';
import 'package:harmonymusic/data/datasources/playlist_remote_data_source.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistRemoteDataSource remoteDataSource;

  PlaylistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PlaylistDetailEntity> getOnlinePlaylist(String playlistId) async {
    try {
      final playlistModel = await remoteDataSource.getOnlinePlaylist(playlistId);
      return playlistModel;
    } catch (e) {
      // Handle exceptions and convert them to domain-specific errors if needed
      rethrow;
    }
  }
}
