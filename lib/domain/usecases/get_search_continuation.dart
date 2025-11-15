import 'package:harmonymusic/domain/entities/search_result_entity.dart';
import 'package:harmonymusic/domain/repositories/search_repository.dart';

class GetSearchContinuation {
  final SearchRepository repository;

  GetSearchContinuation(this.repository);

  Future<SearchResultEntity> call(Map additionalParamsNext, {int limit = 10}) {
    return repository.getSearchContinuation(additionalParamsNext, limit: limit);
  }
}
