import 'package:harmonymusic/data/home/datasources/home_remote_data_source.dart';
import 'package:harmonymusic/domain/home/entities/home_section_entity.dart';
import 'package:harmonymusic/domain/home/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  // We could add a local data source here for caching in the future.

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HomeSectionEntity>> getHomeContent() async {
    try {
      final homeSections = await remoteDataSource.getHomeContent();
      // The models returned by the data source are compatible with the entities.
      return homeSections;
    } catch (e) {
      throw Exception('Failed to get home content from repository.');
    }
  }
}
