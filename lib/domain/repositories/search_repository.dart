import 'package:harmonymusic/domain/entities/search_result_entity.dart';

abstract class SearchRepository {
  Future<SearchResultEntity> search(String query, {String? filter});
}
