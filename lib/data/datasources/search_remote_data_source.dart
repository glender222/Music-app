import 'package:harmonymusic/services/music_service.dart';
import 'package:harmonymusic/data/models/search_result_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultModel> search(String query, {String? filter});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final MusicServices musicServices;

  SearchRemoteDataSourceImpl({required this.musicServices});

  @override
  Future<SearchResultModel> search(String query, {String? filter}) async {
    final result = await musicServices.search(query, filter: filter);
    return SearchResultModel.fromJson(result);
  }
}
