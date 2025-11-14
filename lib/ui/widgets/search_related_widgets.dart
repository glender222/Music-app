import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/domain/entities/search_result_entity.dart';
import 'package:harmonymusic/models/album.dart';
import 'package:harmonymusic/models/artist.dart';
import 'package:harmonymusic/models/playlist.dart';

import '/ui/widgets/content_list_widget.dart';
import 'separate_tab_item_widget.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    super.key,
    this.isv2Used = false,
    required this.searchResult,
    required this.queryString,
  });

  final bool isv2Used;
  final SearchResultEntity searchResult;
  final String queryString;

  @override
  Widget build(BuildContext context) {
    final topPadding = context.isLandscape ? 50.0 : 80.0;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 200, top: isv2Used ? 0 : topPadding),
          child: Column(children: [
            if (!isv2Used)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "searchRes".tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            if (!isv2Used)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${"for1".tr} \"$queryString\"",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            ...generateWidgetList(searchResult),
          ]),
        ),
      ),
    );
  }

  List<Widget> generateWidgetList(SearchResultEntity searchResult) {
    List<Widget> list = [];

    if (searchResult.songs.isNotEmpty) {
      list.add(SeparateTabItemWidget(
        items: searchResult.songs
            .map((e) => MediaItem(
                  id: e.id,
                  title: e.title,
                  album: e.album,
                  artist: e.artist,
                  artUri: Uri.parse(e.thumbnailUrl),
                  duration: e.duration,
                ))
            .toList(),
        title: "Songs",
        isCompleteList: false,
      ));
    }

    if (searchResult.videos.isNotEmpty) {
      list.add(SeparateTabItemWidget(
        items: searchResult.videos
            .map((e) => MediaItem(
                  id: e.id,
                  title: e.title,
                  artist: e.author,
                  artUri: Uri.parse(e.thumbnailUrl),
                  extras: {'views': e.views, 'length': e.length},
                ))
            .toList(),
        title: "Videos",
        isCompleteList: false,
      ));
    }

    if (searchResult.albums.isNotEmpty) {
      list.add(ContentListWidget(
        content: AlbumContent(
          title: "Albums",
          albumList: searchResult.albums
              .map((e) => Album(
                    browseId: e.browseId,
                    title: e.title,
                    year: e.year,
                    thumbnailUrl: e.thumbnailUrl,
                    artists: e.artists
                        ?.map((a) => {'name': a.name, 'id': a.browseId})
                        .toList(),
                  ))
              .toList(),
        ),
        isHomeContent: false,
      ));
    }

    if (searchResult.artists.isNotEmpty) {
      list.add(SeparateTabItemWidget(
        items: searchResult.artists
            .map((e) => Artist(
                  browseId: e.browseId,
                  name: e.name,
                  thumbnailUrl: e.thumbnailUrl,
                  subscribers: e.subscribers,
                ))
            .toList(),
        title: "Artists",
        isCompleteList: false,
      ));
    }

    if (searchResult.playlists.isNotEmpty) {
      list.add(ContentListWidget(
          content: PlaylistContent(
            title: "Playlists",
            playlistList: searchResult.playlists
                .map((e) => Playlist(
                      playlistId: e.browseId,
                      title: e.title,
                      thumbnailUrl: e.thumbnailUrl,
                      songCount: e.songCount,
                    ))
                .toList(),
          ),
          isHomeContent: false));
    }

    return list;
  }
}
