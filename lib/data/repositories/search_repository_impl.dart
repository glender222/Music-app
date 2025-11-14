import 'package:harmonymusic/domain/entities/search_result_entity.dart';
import 'package:harmonymusic/domain/repositories/search_repository.dart';
import 'package:harmonymusic/data/datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SearchResultEntity> search(String query, {String? filter}) async {
    try {
      final searchResultModel = await remoteDataSource.search(query, filter: filter);
      return searchResultModel;
    } catch (e) {
      // Here you can handle exceptions, e.g., by throwing a domain-specific exception
      rethrow;
    }
  }
}
