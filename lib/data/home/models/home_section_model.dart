import 'package:harmonymusic/domain/home/entities/home_section_entity.dart';
import 'package:harmonymusic/data/home/models/album_model.dart';
import 'package:harmonymusic/data/playlist/models/playlist_model.dart';

class HomeSectionModel extends HomeSectionEntity {
  HomeSectionModel({
    required super.title,
    required super.items,
  });

  factory HomeSectionModel.fromLegacyContent(dynamic content) {
    final String title = content.title;
    final List<dynamic> items;

    if (content.runtimeType.toString() == 'AlbumContent') {
      items = content.albumList.map((album) => AlbumModel.fromLegacyAlbum(album)).toList();
    } else if (content.runtimeType.toString() == 'PlaylistContent') {
      items = content.playlistList.map((playlist) => PlaylistModel.fromLegacyPlaylist(playlist)).toList();
    } else {
      items = [];
    }

    return HomeSectionModel(title: title, items: items);
  }
}
