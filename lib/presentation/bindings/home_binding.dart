import 'package:get/get.dart';
import 'package:harmonymusic/data/home/datasources/home_remote_data_source.dart';
import 'package:harmonymusic/data/home/repositories/home_repository_impl.dart';
import 'package:harmonymusic/domain/home/repositories/home_repository.dart';
import 'package:harmonymusic/domain/home/usecases/get_home_page_content_usecase.dart';
import 'package:harmonymusic/services/music_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(musicServices: Get.find<MusicServices>()),
    );

    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: Get.find<HomeRemoteDataSource>()),
    );

    Get.lazyPut<GetHomePageContentUseCase>(
      () => GetHomePageContentUseCase(Get.find<HomeRepository>()),
    );
  }
}
