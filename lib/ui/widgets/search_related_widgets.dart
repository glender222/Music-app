import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/domain/entities/search_result_entity.dart';
import 'package:harmonymusic/ui/widgets/content_list_widget.dart';
import 'package:harmonymusic/ui/widgets/separate_tab_item_widget.dart';
import 'package:harmonymusic/ui/widgets/sort_widget.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    super.key,
    this.isv2Used = false,
    required this.searchResult,
    required this.queryString,
    required this.onViewAllPressed,
    required this.onSort,
  });

  final bool isv2Used;
  final SearchResultEntity searchResult;
  final String queryString;
  final Function(String) onViewAllPressed;
  final Function(SortType, bool, String) onSort;

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
            ..._generateWidgetList(),
          ]),
        ),
      ),
    );
  }

  List<Widget> _generateWidgetList() {
    List<Widget> list = [];

    if (searchResult.songs.isNotEmpty) {
      list.add(SeparateTabItemWidget(
        items: searchResult.songs,
        title: "Songs",
        isCompleteList: false,
        onSort: (sortType, isAscending) => onSort(sortType, isAscending, "Songs"),
      ));
    }

    if (searchResult.videos.isNotEmpty) {
      list.add(SeparateTabItemWidget(
        items: searchResult.videos,
        title: "Videos",
        isCompleteList: false,
        onSort: (sortType, isAscending) => onSort(sortType, isAscending, "Videos"),
      ));
    }

    if (searchResult.albums.isNotEmpty) {
      list.add(ContentListWidget(
        title: "Albums",
        itemList: searchResult.albums,
        isHomeContent: false,
        onViewAllPressed: () => onViewAllPressed("Albums"),
      ));
    }

    if (searchResult.artists.isNotEmpty) {
      list.add(SeparateTabItemWidget(
        items: searchResult.artists,
        title: "Artists",
        isCompleteList: false,
        onSort: (sortType, isAscending) => onSort(sortType, isAscending, "Artists"),
      ));
    }

    if (searchResult.playlists.isNotEmpty) {
      list.add(ContentListWidget(
        title: "Playlists",
        itemList: searchResult.playlists,
        isHomeContent: false,
        onViewAllPressed: () => onViewAllPressed("Playlists"),
      ));
    }

    return list;
  }
}
