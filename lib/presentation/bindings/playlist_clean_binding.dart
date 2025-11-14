import 'package:get/get.dart';
import 'package:harmonymusic/data/datasources/playlist_remote_data_source.dart';
import 'package:harmonymusic/data/repositories/playlist_repository_impl.dart';
import 'package:harmonymusic/domain/repositories/playlist_repository.dart';
import 'package:harmonymusic/domain/usecases/get_online_playlist.dart';
import 'package:harmonymusic/presentation/controllers/playlist_clean_controller.dart';

class PlaylistCleanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaylistRemoteDataSource>(
      () => PlaylistRemoteDataSourceImpl(musicServices: Get.find()),
    );

    Get.lazyPut<PlaylistRepository>(
      () => PlaylistRepositoryImpl(remoteDataSource: Get.find()),
    );

    Get.lazyPut<GetOnlinePlaylist>(
      () => GetOnlinePlaylist(Get.find()),
    );

    Get.lazyPut<PlaylistCleanController>(
      () => PlaylistCleanController(getOnlinePlaylist: Get.find()),
    );
  }
}
