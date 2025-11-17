import 'package:harmonymusic/data/home/models/home_section_model.dart';
import 'package:harmonymusic/models/album.dart';
import 'package:harmonymusic/models/playlist.dart';
import 'package:harmonymusic/services/music_service.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeSectionModel>> getHomeContent();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final MusicServices musicServices;

  HomeRemoteDataSourceImpl({required this.musicServices});

  @override
  Future<List<HomeSectionModel>> getHomeContent() async {
    try {
      final homeContentListMap = await musicServices.getHome();

      final List<HomeSectionModel> sections = [];

      for (var content in homeContentListMap) {
        if ((content["contents"][0]).runtimeType == Playlist) {
          final tmp = PlaylistContent(
              playlistList: (content["contents"]).whereType<Playlist>().toList(),
              title: content["title"]);
          if (tmp.playlistList.length >= 2) {
            sections.add(HomeSectionModel.fromLegacyContent(tmp));
          }
        } else if ((content["contents"][0]).runtimeType == Album) {
          final tmp = AlbumContent(
              albumList: (content["contents"]).whereType<Album>().toList(),
              title: content["title"]);
          if (tmp.albumList.length >= 2) {
            sections.add(HomeSectionModel.fromLegacyContent(tmp));
          }
        }
      }
      return sections;
    } catch (e) {
      throw Exception('Failed to fetch home content.');
    }
  }
}
