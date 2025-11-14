import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widget_marquee/widget_marquee.dart';
import 'package:harmonymusic/models/playlist.dart';
import 'package:harmonymusic/presentation/controllers/playlist_clean_controller.dart';
import 'package:harmonymusic/domain/entities/playlist_detail_entity.dart';

import '/models/playling_from.dart';
import '/models/thumbnail.dart';
import '/ui/widgets/playlist_album_scroll_behaviour.dart';
import '../../../services/downloader.dart';
import '../../navigator.dart';
import '../../player/player_controller.dart';
import '../../widgets/create_playlist_dialog.dart';
import '../../widgets/loader.dart';
import '../../widgets/playlist_export_dialog.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/song_list_tile.dart';
import '../../widgets/songinfo_bottom_sheet.dart';
import '../../widgets/sort_widget.dart';
import '../Library/library_controller.dart';
import 'playlist_screen_controller.dart';

class PlaylistScreen extends GetView<PlaylistCleanController> {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tag = key.hashCode.toString();
    // Keep the old controller for now for actions and local playlist logic
    final playlistController =
        (Get.isRegistered<PlaylistScreenController>(tag: tag))
            ? Get.find<PlaylistScreenController>(tag: tag)
            : Get.put(PlaylistScreenController(), tag: tag);

    final args = Get.arguments as List;
    final playlistFromArgs = args[0] as Playlist?;
    final playlistId = args[1] as String;

    // Decide if we should use the new architecture or the old one
    final bool useCleanArchitecture = playlistFromArgs == null || playlistFromArgs.isCloudPlaylist;

    if (useCleanArchitecture) {
      // Trigger fetch only if not already loaded
      if (controller.playlist.value == null) {
        controller.fetchOnlinePlaylist(playlistId);
      }
    }

    final size = MediaQuery.of(context).size;
    final playerController = Get.find<PlayerController>();
    final landscape = size.width > size.height;

    return Scaffold(
      body: Obx(() {
        // The main reactive widget that handles loading/error/success for the new architecture
        if (useCleanArchitecture) {
          if (controller.isLoading.value) {
            return const Center(child: LoadingIndicator());
          }
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }
          if (controller.playlist.value == null) {
            // This can be a loading state or an empty state after a failed fetch
            return const Center(child: Text("Loading playlist..."));
          }
        }

        // Determine which data to show
        final PlaylistDetailEntity? playlistEntity = controller.playlist.value;
        final Playlist oldPlaylist = playlistController.playlist.value;
        final songList = useCleanArchitecture
            ? playlistEntity!.tracks
                .map((song) => MediaItem(
                      id: song.id,
                      title: song.title,
                      artist: song.artist,
                      album: song.album,
                      artUri: Uri.parse(song.thumbnailUrl),
                      duration: song.duration,
                    ))
                .toList()
            : playlistController.songList;

        final title = useCleanArchitecture ? playlistEntity!.title : oldPlaylist.title;
        final thumbnailUrl = useCleanArchitecture ? playlistEntity!.thumbnailUrl : oldPlaylist.thumbnailUrl;
        final description = useCleanArchitecture ? playlistEntity!.description : oldPlaylist.description;

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            final scrollOffset = scrollInfo.metrics.pixels;
            if (landscape) {
              playlistController.scrollOffset.value = 0;
            } else {
              playlistController.scrollOffset.value = scrollOffset;
            }
            if (scrollOffset > 270 || (landscape && scrollOffset > 215)) {
              playlistController.appBarTitleVisible.value = true;
            } else {
              playlistController.appBarTitleVisible.value = false;
            }
            return true;
          },
          child: Stack(
            children: [
              Positioned(
                top: landscape ? 0 : -.25 * playlistController.scrollOffset.value,
                right: landscape ? 0 : null,
                child: Obx(() {
                  final opacityValue = 1 -
                      playlistController.scrollOffset.value /
                          (size.width - 100);
                  return Opacity(
                    opacity: opacityValue < 0 ? 0 : opacityValue,
                    child: DecoratedBox(
                       position: DecorationPosition.foreground,
                       decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color: Theme.of(context).canvasColor,
                             spreadRadius: 200,
                             blurRadius: 100,
                             offset: Offset(-size.height, 0),
                           ),
                           BoxShadow(
                             color: Theme.of(context).canvasColor,
                             spreadRadius: 200,
                             blurRadius: 100,
                             offset: Offset(0, landscape ? size.height : size.width + 80),
                           )
                         ],
                       ),
                      child: CachedNetworkImage(
                        imageUrl: Thumbnail(thumbnailUrl).extraHigh,
                        fit: landscape ? BoxFit.fitHeight : BoxFit.cover,
                        width: landscape ? null : size.width,
                        height: landscape ? size.height : size.width,
                      ),
                    ),
                  );
                }),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: 10,
                        right: 10),
                    height: 80,
                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: IconButton(
                              tooltip: "back".tr,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back_ios)),
                          ),
                          Expanded(
                            child: Obx(
                              () => Marquee(
                                delay: const Duration(milliseconds: 300),
                                duration: const Duration(seconds: 5),
                                id: "${title.hashCode.toString()}_appbar",
                                child: Text(
                                  playlistController.appBarTitleVisible.isTrue
                                      ? title
                                      : "",
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ),
                          // More options button (keep old logic for now)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 800,
                        ),
                        child: ScrollConfiguration(
                          behavior: PlaylistAlbumScrollBehaviour(),
                          child: ListView.builder(
                            addRepaintBoundaries: false,
                            padding: EdgeInsets.only(
                              top: landscape ? 150 : 200,
                              bottom: 200,
                            ),
                            itemCount: songList.isEmpty ? 4 : songList.length + 3,
                            itemBuilder: (_, index) {
                              if (index == 0) {
                                // Action buttons (keep old logic for now)
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: SizedBox(
                                    height: 40,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            tooltip: "play".tr,
                                            onPressed: () {
                                              playerController.playPlayListSong(
                                                  songList, 0,
                                                  playfrom: PlaylingFrom(
                                                      name: title,
                                                      type: PlaylingFromType.PLAYLIST));
                                            },
                                            icon: Icon(
                                              Icons.play_circle,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .color,
                                            )),
                                          // Other buttons...
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else if (index == 1) {
                                return AnimatedBuilder(
                                  animation: playlistController.animationController,
                                  builder: (context, child) {
                                     return SizedBox(
                                      height: playlistController.heightAnimation.value,
                                      child: Transform.scale(
                                        scale: playlistController.scaleAnimation.value,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, bottom: 10, right: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Marquee(
                                          delay: const Duration(milliseconds: 300),
                                          duration: const Duration(seconds: 5),
                                          id: title.hashCode.toString(),
                                          child: Text(
                                            title,
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(fontSize: 30),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Marquee(
                                            delay: const Duration(milliseconds: 300),
                                            duration: const Duration(seconds: 5),
                                            id: description.hashCode.toString(),
                                            child: Text(
                                              description ?? "playlist".tr,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (index == 2) {
                                // Sort widget (keep old logic for now)
                                return SizedBox(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:15.0, right:10),
                                    child: SortWidget(
                                      tag: playlistId,
                                      screenController: playlistController,
                                      itemCountTitle: "${songList.length}",
                                      onSort: playlistController.onSort,
                                      onSearch: playlistController.onSearch,
                                      onSearchClose: playlistController.onSearchClose,
                                      onSearchStart: playlistController.onSearchStart,
                                      // ... other params
                                    ),
                                  ),
                                );
                              } else if (songList.isEmpty) {
                                return SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: Text(
                                      "emptyPlaylist".tr,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ),
                                );
                              }

                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, right: 5),
                                child: SongListTile(
                                  onTap: () {
                                    playerController.playPlayListSong(
                                        songList,
                                        index - 3,
                                        playfrom: PlaylingFrom(
                                            name: title,
                                            type: PlaylingFromType.PLAYLIST));
                                  },
                                  song: songList[index - 3],
                                  isPlaylistOrAlbum: true,
                                  playlist: oldPlaylist, // still needed for some actions
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
