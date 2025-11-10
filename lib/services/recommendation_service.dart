import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'activity_service.dart';
import 'music_service.dart';

class RecommendationService {
  final ActivityService _activityService = Get.find<ActivityService>();
  final MusicServices _musicServices = Get.find<MusicServices>();

  Future<List<Video>> getRecommendations() async {
    final artistCounts = _activityService.getArtistCounts();
    if (artistCounts.isEmpty) {
      return [];
    }

    final sortedArtists = artistCounts.keys.toList(growable: false)
      ..sort((k1, k2) => artistCounts[k2]!.compareTo(artistCounts[k1]!));

    final topArtist = sortedArtists.first;

    final searchResults = await _musicServices.searchSong(topArtist);
    if (searchResults.isNotEmpty) {
      final firstResult = searchResults.first;
      if (firstResult is Video) {
        return searchResults.cast<Video>().toList();
      }
    }
    return [];
  }
}
