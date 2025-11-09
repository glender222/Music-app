import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'activity_service.dart';
import 'piped_service.dart';

class RecommendationService {
  final ActivityService _activityService = Get.find<ActivityService>();
  final PipedServices _pipedServices = Get.find<PipedServices>();

  Future<List<Video>> getRecommendations() async {
    final artistCounts = _activityService.getArtistCounts();
    if (artistCounts.isEmpty) {
      return [];
    }

    final sortedArtists = artistCounts.keys.toList(growable: false)
      ..sort((k1, k2) => artistCounts[k2]!.compareTo(artistCounts[k1]!));

    final topArtist = sortedArtists.first;

    final searchResults = await _pipedServices.search(topArtist);
    return searchResults.videos;
  }
}
