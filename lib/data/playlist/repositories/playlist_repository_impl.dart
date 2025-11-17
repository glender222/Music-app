import 'package:harmonymusic/data/playlist/datasources/playlist_local_data_source.dart';
import 'package:harmonymusic/data/playlist/models/playlist_model.dart';
import 'package:harmonymusic/domain/playlist/entities/playlist_entity.dart';
import 'package:harmonymusic/domain/playlist/repositories/playlist_repository.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistLocalDataSource localDataSource;

  PlaylistRepositoryImpl({required this.localDataSource});

  @override
  Future<void> savePlaylist(PlaylistEntity playlist) async {
    try {
      final playlistModel = PlaylistModel.fromEntity(playlist);
      await localDataSource.savePlaylist(playlistModel);
    } catch (e) {
      throw Exception('Failed to save playlist.');
    }
  }

  @override
  Future<void> removePlaylist(String playlistId) async {
    try {
      await localDataSource.removePlaylist(playlistId);
    } catch (e) {
      throw Exception('Failed to remove playlist.');
    }
  }
}
