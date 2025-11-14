import 'package:harmonymusic/domain/entities/search_result_entity.dart';
import 'package:harmonymusic/domain/repositories/search_repository.dart';

class SearchMusic {
  final SearchRepository repository;

  SearchMusic(this.repository);

  Future<SearchResultEntity> call(String query, {String? filter}) {
    return repository.search(query, filter: filter);
  }
}
