import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import '../repository/download_repository.dart';

class GetCurrentSongUseCase {
  final DownloadRepository _downloadRepository = Get.find<DownloadRepository>();

  Stream<MediaItem?> call() {
    // This is a bit of a hack, since the repository doesn't directly expose the current song.
    // We can derive it from the song queue and the isJobRunning state.
    return _downloadRepository.songQueue.map((queue) {
      if (queue.isNotEmpty && _downloadRepository.isJobRunning.isTrue) {
        return queue.first;
      }
      return null;
    });
  }
}
