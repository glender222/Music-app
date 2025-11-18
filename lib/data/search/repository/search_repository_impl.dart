import 'package:get/get.dart';
import '../../../domain/search/repository/search_repository.dart';
import '../../../services/music_service.dart';

class SearchRepositoryImpl implements SearchRepository {
  final MusicServices _musicServices = Get.find<MusicServices>();

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    return await _musicServices.getSearchSuggestion(query);
  }
}
