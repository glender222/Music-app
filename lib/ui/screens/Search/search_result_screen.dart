import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/screens/Search/search_result_screen_v2.dart';
import '/ui/screens/Settings/settings_screen_controller.dart';
import '../../navigator.dart';
import '../../widgets/animated_screen_transition.dart';
import '../../widgets/loader.dart';
import '../../widgets/search_related_widgets.dart';
import '../../widgets/separate_tab_item_widget.dart';
import 'package:harmonymusic/presentation/controllers/search_clean_controller.dart';
import 'search_result_screen_controller.dart';

class SearchResultScreen extends GetView<SearchCleanController> {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchResScrController = Get.put(SearchResultScreenController());

    // Trigger the search when the widget is built
    final args = Get.arguments;
    if (args != null && controller.searchResult.value == null) {
      controller.search(args);
    }

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
                          onDestinationSelected:
                              searchResScrController.onDestinationSelected,
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
                          selectedIndex: searchResScrController
                              .navigationRailCurrentIndex.value,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GetX<SearchResultScreenController>(
                    builder: (controller) => AnimatedScreenTransition(
                      enabled: Get.find<SettingsScreenController>()
                          .isTransitionAnimationDisabled
                          .isFalse,
                      resverse: controller.isTabTransitionReversed,
                      child: Center(
                        key: ValueKey<int>(
                            controller.navigationRailCurrentIndex.toInt() * 8),
                        child: Body(
                            searchResScrController: searchResScrController),
                      ),
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

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.searchResScrController,
  });

  final SearchResultScreenController searchResScrController;

  @override
  Widget build(BuildContext context) {
    final cleanController = Get.find<SearchCleanController>();

    if (searchResScrController.navigationRailCurrentIndex.value == 0) {
      return Obx(() {
        if (cleanController.isLoading.value) {
          return const Center(child: LoadingIndicator());
        }

        if (cleanController.errorMessage.value.isNotEmpty) {
          return Center(child: Text(cleanController.errorMessage.value));
        }

        final searchResult = cleanController.searchResult.value;
        if (searchResult == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "nomatch".tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text("'${searchResScrController.queryString.value}'"),
              ],
            ),
          );
        }

        return ResultWidget(
          searchResult: searchResult,
          queryString: searchResScrController.queryString.value,
        );
      });
    } else {
      // Logic for other tabs remains unchanged for now
      if (cleanController.searchResult.value != null) {
        final topPadding = context.isLandscape ? 50.0 : 80.0;
        final name = cleanController.railItems[
            searchResScrController.navigationRailCurrentIndex.value - 1];
        return SeparateTabItemWidget(
          items: const [],
          title: name,
          topPadding: topPadding,
          scrollController: searchResScrController.scrollControllers[name],
        );
      }
    }
    return const SizedBox.shrink();
  }
}
