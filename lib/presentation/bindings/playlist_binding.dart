import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:harmonymusic/data/playlist/datasources/playlist_local_data_source.dart';
import 'package:harmonymusic/data/playlist/repositories/playlist_repository_impl.dart';
import '../../domain/playlist/repositories/playlist_repository.dart';
import '../../domain/playlist/usecases/save_playlist_usecase.dart';
import '../../domain/playlist/usecases/remove_playlist_usecase.dart';

class PlaylistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaylistLocalDataSource>(
      () => PlaylistLocalDataSourceImpl(Get.find<HiveInterface>()),
    );

    Get.lazyPut<PlaylistRepository>(
      () => PlaylistRepositoryImpl(localDataSource: Get.find<PlaylistLocalDataSource>()),
    );

    Get.lazyPut<SavePlaylistUseCase>(
      () => SavePlaylistUseCase(Get.find<PlaylistRepository>()),
    );

    Get.lazyPut<RemovePlaylistUseCase>(
      () => RemovePlaylistUseCase(Get.find<PlaylistRepository>()),
    );
  }
}
