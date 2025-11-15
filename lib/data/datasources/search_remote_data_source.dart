import 'package:harmonymusic/services/music_service.dart';
import 'package:harmonymusic/data/models/search_result_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultModel> search(String query, {String? filter, String? scope, int limit = 20, bool ignoreSpelling = false});
  Future<SearchResultModel> getSearchContinuation(Map additionalParamsNext, {int limit = 10});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final MusicServices musicServices;

  SearchRemoteDataSourceImpl({required this.musicServices});

  @override
  Future<SearchResultModel> search(String query, {String? filter, String? scope, int limit = 20, bool ignoreSpelling = false}) async {
    final result = await musicServices.search(query, filter: filter, scope: scope, limit: limit, ignoreSpelling: ignoreSpelling);
    return SearchResultModel.fromJson(result);
  }

  @override
  Future<SearchResultModel> getSearchContinuation(Map additionalParamsNext, {int limit = 10}) async {
    final result = await musicServices.getSearchContinuation(additionalParamsNext, limit: limit);
    return SearchResultModel.fromJson(result);
  }
}
