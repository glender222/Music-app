import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/domain/entities/search_result_entity.dart';
import 'package:harmonymusic/domain/usecases/search_music.dart';
import 'package:harmonymusic/domain/usecases/get_search_continuation.dart';
import 'package:harmonymusic/utils/helper.dart';
import '/ui/widgets/sort_widget.dart';

class SearchCleanController extends GetxController with GetTickerProviderStateMixin {
  final SearchMusic searchMusic;
  final GetSearchContinuation getSearchContinuation;

  SearchCleanController({
    required this.searchMusic,
    required this.getSearchContinuation,
  });

  // State
  final navigationRailCurrentIndex = 0.obs;
  final separatedResultContent = <String, List<dynamic>>{}.obs;
  final queryString = ''.obs;
  final railItems = <String>[].obs;
  final additionalParamNext = <String, dynamic>{}.obs;
  bool continuationInProgress = false;
  TabController? tabController;
  bool isTabTransitionReversed = false;
  final Map<String, ScrollController> scrollControllers = {};

  final Rx<SearchResultEntity?> searchResult = Rx<SearchResultEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onReady() {
    super.onReady();
    final args = Get.arguments;
    if (args != null) {
      search(args);
    }
  }

  Future<void> search(String query) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      queryString.value = query;

      final result = await searchMusic(query);
      searchResult.value = result;

      _populateRailItems(result);
      _initializeTabs();
      _initializeScrollControllers();

    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _populateRailItems(SearchResultEntity result) {
    final items = <String>[];
    if (result.songs.isNotEmpty) items.add("Songs");
    if (result.videos.isNotEmpty) items.add("Videos");
    if (result.albums.isNotEmpty) items.add("Albums");
    if (result.artists.isNotEmpty) items.add("Artists");
    if (result.playlists.isNotEmpty) items.add("Playlists");
    railItems.value = items;
  }

  void _initializeTabs() {
    tabController?.dispose();
    tabController = TabController(length: railItems.length + 1, vsync: this);
    tabController?.animation?.addListener(() {
      int indexChange = tabController!.offset.round();
      int index = tabController!.index + indexChange;

      if (index != navigationRailCurrentIndex.value) {
        onDestinationSelected(index, ignoreTabCommand: true);
      }
    });
  }

  void _initializeScrollControllers() {
    scrollControllers.forEach((_, controller) => controller.dispose());
    scrollControllers.clear();
    for (String item in railItems) {
      scrollControllers[item] = ScrollController();
    }
  }

  Future<void> onDestinationSelected(int value, {bool ignoreTabCommand = false}) async {
    if (railItems.isEmpty) return;

    isTabTransitionReversed = value > navigationRailCurrentIndex.value;
    navigationRailCurrentIndex.value = value;

    if (tabController != null && !ignoreTabCommand) {
      tabController?.animateTo(value);
    }

    if (value > 0 && (!separatedResultContent.containsKey(railItems[value - 1]) || separatedResultContent[railItems[value - 1]]!.isEmpty)) {
      final tabName = railItems[value - 1];

      final result = await searchMusic(queryString.value, filter: tabName.replaceAll(" ", "_").toLowerCase());

      dynamic content;
      if (tabName == "Songs") content = result.songs;
      else if (tabName == "Videos") content = result.videos;
      else if (tabName == "Albums") content = result.albums;
      else if (tabName == "Artists") content = result.artists;
      else if (tabName == "Playlists") content = result.playlists;

      separatedResultContent[tabName] = content;
      additionalParamNext[tabName] = result.continuationParams;

      final scrollController = scrollControllers[tabName];
      scrollController?.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent / 2 && !continuationInProgress) {
          continuationInProgress = true;
          getContinuationContents();
        }
      });
    }
  }

  Future<void> getContinuationContents() async {
    final tabName = railItems[navigationRailCurrentIndex.value - 1];
    final params = additionalParamNext[tabName];
    if (params == null) {
      continuationInProgress = false;
      return;
    }

    final result = await getSearchContinuation(params);

    dynamic newContent;
    if (tabName == "Songs") newContent = result.songs;
    else if (tabName == "Videos") newContent = result.videos;
    else if (tabName == "Albums") newContent = result.albums;
    else if (tabName == "Artists") newContent = result.artists;
    else if (tabName == "Playlists") newContent = result.playlists;

    if (newContent != null) {
      (separatedResultContent[tabName] as List).addAll(newContent);
    }

    additionalParamNext[tabName] = result.continuationParams;
    separatedResultContent.refresh();
    continuationInProgress = false;
  }

  void onSort(SortType sortType, bool isAscending, String title) {
    if (!separatedResultContent.containsKey(title)) return;

    final list = separatedResultContent[title];
    if (list == null) return;

    if (list is List<SongEntity> || list is List<VideoEntity>) {
      sortSongsNVideos(list, sortType, isAscending);
    } else if (list is List<PlaylistSummaryEntity>) {
      sortPlayLists(list, sortType, isAscending);
    } else if (list is List<ArtistSummaryEntity>) {
      sortArtist(list, sortType, isAscending);
    } else if (list is List<AlbumSummaryEntity>) {
      sortAlbumNSingles(list, sortType, isAscending);
    }
    separatedResultContent[title] = list;
    separatedResultContent.refresh();
  }

  @override
  void onClose() {
    tabController?.dispose();
    scrollControllers.forEach((_, controller) => controller.dispose());
    super.onClose();
  }
}
