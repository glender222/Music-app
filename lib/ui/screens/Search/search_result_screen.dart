import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/presentation/controllers/search_clean_controller.dart';
import 'package:harmonymusic/ui/screens/Search/search_result_screen_v2.dart';
import 'package:harmonymusic/ui/screens/Settings/settings_screen_controller.dart';
import 'package:harmonymusic/ui/widgets/animated_screen_transition.dart';
import 'package:harmonymusic/ui/widgets/loader.dart';
import 'package:harmonymusic/ui/widgets/search_related_widgets.dart';
import 'package:harmonymusic/ui/widgets/separate_tab_item_widget.dart';
import 'package:harmonymusic/ui/widgets/sort_widget.dart';
import '../../navigator.dart';

class SearchResultScreen extends GetView<SearchCleanController> {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isDesktop ||
            Get.find<SettingsScreenController>().isBottomNavBarEnabled.isTrue
        ? const SearchResultScreenBN()
        : Scaffold(
            body: Row(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: IntrinsicHeight(
                      child: Obx(
                        () => NavigationRail(
                          onDestinationSelected: controller.onDestinationSelected,
                          minWidth: 60,
                          destinations: (controller.searchResult.value != null &&
                                  controller.railItems.isNotEmpty)
                              ? [
                                  railDestination("results".tr),
                                  ...(controller.railItems.map(
                                      (element) => railDestination(element))),
                                ]
                              : [
                                  railDestination("results".tr),
                                  railDestination("")
                                ],
                          leading: Column(
                            children: [
                              SizedBox(
                                height: context.isLandscape ? 20 : 45,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .color,
                                ),
                                onPressed: () {
                                  Get.nestedKey(ScreenNavigationSetup.id)!
                                      .currentState!
                                      .pop();
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          labelType: NavigationRailLabelType.all,
                          selectedIndex: controller.navigationRailCurrentIndex.value,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedScreenTransition(
                    enabled: Get.find<SettingsScreenController>()
                        .isTransitionAnimationDisabled
                        .isFalse,
                    resverse: controller.isTabTransitionReversed,
                    child: Center(
                      key: ValueKey<int>(
                          controller.navigationRailCurrentIndex.toInt() * 8),
                      child: Body(),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  NavigationRailDestination railDestination(String label) {
    return NavigationRailDestination(
      icon: const SizedBox.shrink(),
      label: RotatedBox(
          quarterTurns: -1,
          child: Text(label.toLowerCase().removeAllWhitespace.tr)),
    );
  }
}

class Body extends GetView<SearchCleanController> {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.navigationRailCurrentIndex.value == 0) {
      return Obx(() {
        if (controller.isLoading.value && controller.searchResult.value == null) {
          return const Center(child: LoadingIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final searchResult = controller.searchResult.value;
        if (searchResult == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "nomatch".tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text("'${controller.queryString.value}'"),
              ],
            ),
          );
        }

        return ResultWidget(
          searchResult: searchResult,
          queryString: controller.queryString.value,
          onViewAllPressed: (String tabName) {
            final index = controller.railItems.indexOf(tabName);
            if (index != -1) {
              controller.onDestinationSelected(index + 1);
            }
          },
          onSort: (SortType sortType, bool isAscending, String title) {
            controller.onSort(sortType, isAscending, title);
          },
        );
      });
    } else {
      return Obx(() {
        if (controller.searchResult.value != null) {
          final topPadding = context.isLandscape ? 50.0 : 80.0;
          final name = controller.railItems[
              controller.navigationRailCurrentIndex.value - 1];
          return SeparateTabItemWidget(
            items: controller.separatedResultContent[name] ?? [],
            title: name,
            topPadding: topPadding,
            scrollController: controller.scrollControllers[name],
            onSort: (sortType, isAscending) {
              controller.onSort(sortType, isAscending, name);
            },
          );
        }
        return const SizedBox.shrink();
      });
    }
  }
}
