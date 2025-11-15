import 'package.harmonymusic/domain/entities/search_result_entity.dart';

abstract class SearchRepository {
  Future<SearchResultEntity> search(String query, {String? filter, String? scope, int limit = 20, bool ignoreSpelling = false});
  Future<SearchResultEntity> getSearchContinuation(Map additionalParamsNext, {int limit = 10});
}
