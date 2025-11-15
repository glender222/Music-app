import 'package:get/get.dart';
import 'package:harmonymusic/data/datasources/search_remote_data_source.dart';
import 'package:harmonymusic/data/repositories/search_repository_impl.dart';
import 'package:harmonymusic/domain/repositories/search_repository.dart';
import 'package:harmonymusic/domain/usecases/get_search_continuation.dart';
import 'package:harmonymusic/domain/usecases/search_music.dart';
import 'package:harmonymusic/presentation/controllers/search_clean_controller.dart';
import 'package:harmonymusic/services/music_service.dart';

class SearchCleanBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MusicServices>()) {
      Get.lazyPut(() => MusicServices());
    }

    Get.lazyPut<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(musicServices: Get.find()),
    );

    Get.lazyPut<SearchRepository>(
      () => SearchRepositoryImpl(remoteDataSource: Get.find()),
    );

    Get.lazyPut<SearchMusic>(
      () => SearchMusic(Get.find()),
    );

    Get.lazyPut<GetSearchContinuation>(
      () => GetSearchContinuation(Get.find()),
    );

    Get.lazyPut<SearchCleanController>(
      () => SearchCleanController(
        searchMusic: Get.find(),
        getSearchContinuation: Get.find(),
      ),
    );
  }
}
