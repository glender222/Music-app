import 'package:harmonymusic/domain/home/entities/home_section_entity.dart';

abstract class HomeRepository {
  Future<List<HomeSectionEntity>> getHomeContent();
}
