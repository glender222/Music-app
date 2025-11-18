import 'package:audio_service/audio_service.dart' show MediaItem;
import 'package:harmonymusic/services/recommendation_service.dart';

abstract class RecommendationDataSource {
  Future<List<MediaItem>> getRecommendations();
}

class RecommendationDataSourceImpl implements RecommendationDataSource {
  final RecommendationService recommendationService;

  RecommendationDataSourceImpl({required this.recommendationService});

  @override
  Future<List<MediaItem>> getRecommendations() async {
    return recommendationService.getRecommendations();
  }
}
