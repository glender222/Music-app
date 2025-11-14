import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/presentation/controllers/search_clean_controller.dart';
import 'package:harmonymusic/ui/screens/Settings/settings_screen_controller.dart';

import '../../../utils/helper.dart';
import '../Home/home_screen_controller.dart';
import '/services/music_service.dart';
import '/ui/widgets/sort_widget.dart';

class SearchResultScreenController extends GetxController
    with GetTickerProviderStateMixin {
  final navigationRailCurrentIndex = 0.obs;
  final isSeparatedResultContentFetced = false.obs;
  final separatedResultContent = <String, dynamic>{}.obs;
  final musicServices = Get.find<MusicServices>();
  final queryString = ''.obs;
  final additionalParamNext = {};
  bool continuationInProgress = false;
  TabController? tabController;
  bool isTabTransitionReversed = false;
  //ScrollContollers List
  final Map<String, ScrollController> scrollControllers = {};

  late final SearchCleanController _searchCleanController;

  @override
  void onInit() {
    super.onInit();
    _searchCleanController = Get.find<SearchCleanController>();
    // Listen to changes in railItems from the clean controller
    ever(_searchCleanController.railItems, _handleRailItemsChanged);
  }

  @override
  void onReady() {
    _initialize();
    Get.find<HomeScreenController>().whenHomeScreenOnTop();
    super.onReady();
  }

  void _handleRailItemsChanged(List<String> newRailItems) {
    // Dispose the old controller if it exists
    tabController?.dispose();

    // Initialize a new TabController
    tabController = TabController(length: newRailItems.length + 1, vsync: this);
    tabController?.animation?.addListener(_handleTabAnimation);

    // Initialize scroll controllers for the new items
    for (String item in newRailItems) {
      if (!scrollControllers.containsKey(item)) {
        scrollControllers[item] = ScrollController();
      }
    }
  }

  void _handleTabAnimation() {
    int indexChange = tabController!.offset.round();
    int index = tabController!.index + indexChange;

    if (index != navigationRailCurrentIndex.value) {
      onDestinationSelected(index, ignoreTabCommand: true);
    }
  }

  Future<void> onDestinationSelected(int value,
      {bool ignoreTabCommand = false}) async {
    final railItems = _searchCleanController.railItems;
    if (railItems.isEmpty) {
      return;
    }

    isTabTransitionReversed = value > navigationRailCurrentIndex.value;

    isSeparatedResultContentFetced.value = false;
    navigationRailCurrentIndex.value = value;

    if (tabController != null && !ignoreTabCommand) {
      tabController?.animateTo(value);
    }

    if (value > 0 &&
        (!separatedResultContent.containsKey(railItems[value - 1]) ||
            separatedResultContent[railItems[value - 1]].isEmpty)) {
      final tabName = railItems[value - 1];
      final itemCount = (tabName == 'Songs' || tabName == 'Videos') ? 25 : 10;
      final x = await musicServices.search(queryString.value,
          filter: tabName.replaceAll(" ", "_").toLowerCase(), limit: itemCount);
      separatedResultContent[tabName] = x[tabName];
      additionalParamNext[tabName] = x['params'];
      isSeparatedResultContentFetced.value = true;
      final scrollController = scrollControllers[tabName];
      (scrollController)!.addListener(() {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.position.pixels;
        if (currentScroll >= maxScroll / 2 &&
            additionalParamNext[tabName]['additionalParams'] !=
                '&ctoken=null&continuation=null') {
          if (!continuationInProgress) {
            printINFO("Acchhsk");
            continuationInProgress = true;
            getContinuationContents();
          }
        }
      });
    }
    isSeparatedResultContentFetced.value = true;
  }

  Future<void> getContinuationContents() async {
    final railItems = _searchCleanController.railItems;
    final tabName = railItems[navigationRailCurrentIndex.value - 1];

    final x =
        await musicServices.getSearchContinuation(additionalParamNext[tabName]);
    (separatedResultContent[tabName]).addAll(x[tabName]);
    additionalParamNext[tabName] = x['params'];
    separatedResultContent.refresh();

    continuationInProgress = false;
  }

  void viewAllCallback(String text) {
    final railItems = _searchCleanController.railItems;
    onDestinationSelected(railItems.indexOf(text) + 1);
  }

  void _initialize() {
    final args = Get.arguments;
    if (args != null) {
      queryString.value = args;
    }
  }

  void onSort(SortType sortType, bool isAscending, String title) {
    if (title == "Songs" || title == "Videos") {
      final songList = separatedResultContent[title].toList();
      sortSongsNVideos(songList, sortType, isAscending);
      separatedResultContent[title] = songList;
    } else if (title.contains('playlists')) {
      final playlists = separatedResultContent[title].toList();
      sortPlayLists(playlists, sortType, isAscending);
      separatedResultContent[title] = playlists;
    } else if (title == "Artists") {
      final artistList = separatedResultContent[title].toList();
      sortArtist(artistList, sortType, isAscending);
      separatedResultContent[title] = artistList;
    } else if (title == "Albums") {
      final albumList = separatedResultContent[title].toList();
      sortAlbumNSingles(albumList, sortType, isAscending);
      separatedResultContent[title] = albumList;
    }
  }

  @override
  void onClose() {
    for (var controller in scrollControllers.values) {
      controller.dispose();
    }
    Get.find<HomeScreenController>().whenHomeScreenOnTop();
    tabController?.removeListener(_handleTabAnimation);
    tabController?.dispose();
    super.onClose();
  }
}
