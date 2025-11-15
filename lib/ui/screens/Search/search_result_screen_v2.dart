import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/presentation/controllers/search_clean_controller.dart';
import 'package:harmonymusic/ui/widgets/loader.dart';
import 'package:harmonymusic/ui/widgets/search_related_widgets.dart';
import 'package:harmonymusic/ui/widgets/sort_widget.dart';

import '../../navigator.dart';
import '../../widgets/separate_tab_item_widget.dart';

class SearchResultScreenBN extends GetView<SearchCleanController> {
  const SearchResultScreenBN({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = context.isLandscape ? 50.0 : 80.0;
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
                          "${"for1".tr} \"${controller.queryString.value}\"",
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
                    if (controller.isLoading.value && controller.searchResult.value == null) {
                      return const Center(child: LoadingIndicator());
                    }

                    if (controller.errorMessage.value.isNotEmpty) {
                      return Center(child: Text(controller.errorMessage.value));
                    }

                    if (controller.searchResult.value == null || controller.railItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "nomatch".tr,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                                "'${controller.queryString.value}'"),
                          ],
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10),
                          child: ButtonsTabBar(
                            onTap: controller.onDestinationSelected,
                            controller: controller.tabController,
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
                              controller: controller.tabController,
                              children: [
                                ResultWidget(
                                  isv2Used: true,
                                  searchResult: controller.searchResult.value!,
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
                                ),
                                ...controller.railItems
                                    .map((tabName) {
                                  return SeparateTabItemWidget(
                                    isResultWidget: true,
                                    hideTitle: true,
                                    items: controller.separatedResultContent[tabName] ?? [],
                                    title: tabName,
                                    isCompleteList: true,
                                    scrollController:
                                        controller.scrollControllers[tabName],
                                    onSort: (sortType, isAscending) {
                                      controller.onSort(sortType, isAscending, tabName);
                                    },
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
