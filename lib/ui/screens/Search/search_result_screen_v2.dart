import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/presentation/controllers/search_clean_controller.dart';
import 'package:harmonymusic/ui/widgets/loader.dart';
import 'package:harmonymusic/ui/widgets/search_related_widgets.dart';

import '../../navigator.dart';
import '../../widgets/separate_tab_item_widget.dart';
import 'search_result_screen_controller.dart';

class SearchResultScreenBN extends GetView<SearchCleanController> {
  const SearchResultScreenBN({super.key});

  @override
  Widget build(BuildContext context) {
    // We still need the old controller for tab management for now
    final searchResScrController = Get.find<SearchResultScreenController>();
    final topPadding = context.isLandscape ? 50.0 : 80.0;

    // The search is already triggered by SearchResultScreen, so we just observe the state
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(
            top: topPadding,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 55,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Get.nestedKey(ScreenNavigationSetup.id)!
                              .currentState!
                              .pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "searchRes".tr,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Obx(
                        () => Text(
                          "${"for1".tr} \"${searchResScrController.queryString.value}\"",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ]))
                ],
              ),
              Expanded(
                child: Obx(
                  () {
                    if (controller.isLoading.value) {
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
                            Text(
                                "'${searchResScrController.queryString.value}'"),
                          ],
                        ),
                      );
                    }

                    // We have results, build the tab bar UI
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10),
                          child: ButtonsTabBar(
                            onTap:
                                searchResScrController.onDestinationSelected,
                            controller: searchResScrController.tabController,
                            contentPadding:
                                const EdgeInsets.only(left: 15, right: 15),
                            backgroundColor:
                                Theme.of(context).textTheme.titleMedium?.color!,
                            unselectedBackgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            borderWidth: 0,
                            buttonMargin: const EdgeInsets.only(
                                right: 10, left: 4, top: 4, bottom: 4),
                            borderColor: Colors.black,
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            unselectedLabelStyle: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.color!,
                              fontWeight: FontWeight.bold,
                            ),
                            tabs: [
                              Tab(text: "results".tr),
                              ...controller.railItems
                                  .map((item) => Tab(
                                        text: item
                                            .toLowerCase()
                                            .removeAllWhitespace
                                            .tr,
                                      ))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: TabBarView(
                              controller: searchResScrController.tabController,
                              children: [
                                ResultWidget(
                                  isv2Used: true,
                                  searchResult: searchResult,
                                  queryString:
                                      searchResScrController.queryString.value,
                                ),
                                ...controller.railItems
                                    .map((tabName) {
                                  // This part still depends on the old controller for separated tabs.
                                  // This will be refactored in a future step.
                                  return SeparateTabItemWidget(
                                    title: tabName,
                                    hideTitle: true,
                                    items: const [],
                                    scrollController: searchResScrController
                                        .scrollControllers[tabName],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}
