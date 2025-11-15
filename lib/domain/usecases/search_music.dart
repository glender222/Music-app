import 'package:harmonymusic/domain/entities/search_result_entity.dart';
import 'package:harmonymusic/domain/repositories/search_repository.dart';

class SearchMusic {
  final SearchRepository repository;

  SearchMusic(this.repository);

  Future<SearchResultEntity> call(String query, {String? filter, String? scope, int limit = 20, bool ignoreSpelling = false}) {
    return repository.search(query, filter: filter, scope: scope, limit: limit, ignoreSpelling: ignoreSpelling);
  }
}
