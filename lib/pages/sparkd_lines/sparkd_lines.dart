import 'dart:io';

import 'package:buddy_ai_wingman/pages/sparkd_lines/sparkd_lines_controller.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/widgets/lines_widget.dart';

class buddy_ai_wingmanLinesPage extends StatelessWidget {
  const buddy_ai_wingmanLinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    print('Screen Height: $screenHeight');

    // Determine number of items per row based on screen height
    int itemsPerRow;
    if (screenHeight >= 600 && screenHeight <= 776) {
      itemsPerRow = 7;
    } else if (screenHeight >= 940 && screenHeight <= 1000) {
      itemsPerRow = 5;
    }else if (screenHeight >= 926 && screenHeight <= 940) {
      itemsPerRow = Platform.isIOS ? 4 : 4;
    }  
    else if (screenHeight >= 800 && screenHeight < 940) {
      itemsPerRow = 6;
    } else {
      itemsPerRow = 7;
    }

    return GetBuilder<buddy_ai_wingmanLinesController>(
      init: buddy_ai_wingmanLinesController(),
      builder: (controller) {
        return Scaffold(
          appBar: const buddy_ai_wingmanAppBar(),
          body: SafeArea(
            child: Column(
              children: [
                SB.h(20),
                Text(
                  AppStrings.getbuddy_ai_wingmanLines,
                  style: context.headlineMedium?.copyWith(
                    color: context.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ).paddingSymmetric(vertical: 10),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const SearchScreen()); // Navigate to SearchScreen on tap
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 13),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 10,),
                        Text(
                          'Search',
                          style: TextStyle(
            
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ).paddingAll(20),
                ),
                Expanded(
                  child: ScrollLoopAutoScroll(
                    scrollDirection: Axis.horizontal,
                    gap: 0.0,
                    duration: const Duration(seconds: 700),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(controller.linesList.length ~/ itemsPerRow, (i) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(itemsPerRow, (j) {
                              return LinesWidget(
                                data: controller.linesList[i * itemsPerRow + j],
                              );
                            }),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    // Reset the search when the screen is initialized
    final controller = Get.find<buddy_ai_wingmanLinesController>();
    controller.resetSearch();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<buddy_ai_wingmanLinesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.resetSearch(); // Reset search on back press
            Get.back(); // Navigate back
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomTextField(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    Assets.icons.search.path,
                  ),
                ),
                hintText: 'Search',
                onChange: (value) {
                  controller.filterLines(value);
                },
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.filteredList.isEmpty) {
                  return const Center(child: Text('No results found'));
                } else {
                  return ListView.builder(
                    itemCount: controller.filteredList.length,
                    itemBuilder: (context, index) {
                      return LinesWidget(
                        data: controller.filteredList[index],
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
