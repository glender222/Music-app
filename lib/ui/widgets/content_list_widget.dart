import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/models/album.dart';
import 'package:harmonymusic/models/playlist.dart';
import 'package:harmonymusic/ui/widgets/album_song_tile_widget.dart';
import 'package:harmonymusic/ui/widgets/playlist_tile_widget.dart';
import 'package:harmonymusic/domain/entities/search_result_entity.dart';

class ContentListWidget extends StatelessWidget {
  const ContentListWidget({
    super.key,
    required this.title,
    this.itemList,
    this.isHomeContent = true,
    this.onViewAllPressed,
  });

  final String title;
  final List<dynamic>? itemList;
  final bool isHomeContent;
  final VoidCallback? onViewAllPressed;

  @override
  Widget build(BuildContext context) {
    if (itemList == null || itemList!.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool isAlbum = itemList!.first is AlbumSummaryEntity;
    final bool isPlaylist = itemList!.first is PlaylistSummaryEntity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (onViewAllPressed != null)
                TextButton(
                  onPressed: onViewAllPressed,
                  child: Text(
                    "viewAll".tr,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                )
            ],
          ),
        ),
        SizedBox(
          height: isAlbum ? 220 : 250,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final item = itemList![index];
              if (isAlbum) {
                final albumEntity = item as AlbumSummaryEntity;
                final album = Album(
                  browseId: albumEntity.browseId,
                  title: albumEntity.title,
                  year: albumEntity.year,
                  thumbnailUrl: albumEntity.thumbnailUrl,
                  artists: albumEntity.artists?.map((a) => {'name': a.name, 'id': a.browseId}).toList(),
                );
                return AlbumTile(album: album);
              } else if (isPlaylist) {
                final playlistEntity = item as PlaylistSummaryEntity;
                final playlist = Playlist(
                  playlistId: playlistEntity.browseId,
                  title: playlistEntity.title,
                  thumbnailUrl: playlistEntity.thumbnailUrl,
                  songCount: playlistEntity.songCount,
                );
                return PlaylistTile(playlist: playlist);
              }
              return null;
            },
            separatorBuilder: (_, __) => const SizedBox(
              width: 15,
            ),
            itemCount: itemList!.length,
          ),
        ),
      ],
    );
  }
}
