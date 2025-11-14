import 'package:get/get.dart';
import 'package:harmonymusic/domain/entities/search_result_entity.dart';
import 'package:harmonymusic/domain/usecases/search_music.dart';

class SearchCleanController extends GetxController {
  final SearchMusic searchMusic;

  SearchCleanController({required this.searchMusic});

  final Rx<SearchResultEntity?> searchResult = Rx<SearchResultEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<String> railItems = <String>[].obs;

  Future<void> search(String query) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      railItems.clear();

      final result = await searchMusic(query);
      searchResult.value = result;

      // Populate railItems from the result
      if (result.songs.isNotEmpty) railItems.add("Songs");
      if (result.videos.isNotEmpty) railItems.add("Videos");
      if (result.albums.isNotEmpty) railItems.add("Albums");
      if (result.artists.isNotEmpty) railItems.add("Artists");
      if (result.playlists.isNotEmpty) railItems.add("Playlists");

    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
