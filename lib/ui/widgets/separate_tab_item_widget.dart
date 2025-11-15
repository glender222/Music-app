import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/domain/entities/search_result_entity.dart';
import 'package:harmonymusic/models/artist.dart';
import 'package:harmonymusic/ui/widgets/artist_tile_widget.dart';
import 'package:harmonymusic/ui/widgets/song_list_tile.dart';
import 'package:harmonymusic/ui/widgets/sort_widget.dart';
import 'package:audio_service/audio_service.dart';

class SeparateTabItemWidget extends StatelessWidget {
  const SeparateTabItemWidget({
    super.key,
    required this.items,
    required this.title,
    this.topPadding = 0,
    this.isCompleteList = false,
    this.scrollController,
    this.hideTitle = false,
    this.isResultWidget = false,
    required this.onSort,
  });

  final String title;
  final List items;
  final double topPadding;
  final bool isCompleteList;
  final ScrollController? scrollController;
  final bool hideTitle;
  final bool isResultWidget;
  final Function(SortType, bool) onSort;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: isResultWidget ? 0 : 30.0,
        right: isResultWidget ? 20 : 30.0,
      ),
      child: Column(
        children: [
          if (!hideTitle)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SortWidget(
                itemCountTitle: items.length.toString(),
                titleLeftPadding: 0,
                requiredSortTypes: const {},
                onSort: (sortType, isAscending) => onSort(sortType, isAscending),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                if (item is ArtistSummaryEntity) {
                  final artist = Artist(
                    browseId: item.browseId,
                    name: item.name,
                    thumbnailUrl: item.thumbnailUrl,
                    subscribers: item.subscribers,
                  );
                  return ArtistTile(artist: artist);
                }
                if (item is SongEntity) {
                   final mediaItem = MediaItem(
                    id: item.id,
                    title: item.title,
                    album: item.album,
                    artist: item.artist,
                    artUri: Uri.parse(item.thumbnailUrl),
                    duration: item.duration,
                  );
                  return SongListTile(song: mediaItem, isPlaylistOrAlbum: false);
                }
                if (item is VideoEntity) {
                   final mediaItem = MediaItem(
                    id: item.id,
                    title: item.title,
                    artist: item.author,
                    artUri: Uri.parse(item.thumbnailUrl),
                    extras: {'views': item.views, 'length': item.length},
                  );
                  return SongListTile(song: mediaItem, isPlaylistOrAlbum: false);
                }
                // Fallback for MediaItem from old logic if needed
                if (item is MediaItem) {
                  return SongListTile(song: item, isPlaylistOrAlbum: false);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
