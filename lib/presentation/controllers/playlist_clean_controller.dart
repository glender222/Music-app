import 'package:get/get.dart';
import 'package:harmonymusic/domain/entities/playlist_detail_entity.dart';
import 'package:harmonymusic/domain/usecases/get_online_playlist.dart';

class PlaylistCleanController extends GetxController {
  final GetOnlinePlaylist getOnlinePlaylist;

  PlaylistCleanController({required this.getOnlinePlaylist});

  final Rx<PlaylistDetailEntity?> playlist = Rx<PlaylistDetailEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchOnlinePlaylist(String playlistId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await getOnlinePlaylist(playlistId);
      playlist.value = result;
    } catch (e) {
      errorMessage.value = 'An error occurred while fetching the playlist: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
