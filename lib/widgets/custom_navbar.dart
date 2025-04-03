import 'package:buddy_ai_wingman/core/constants/imports.dart';

import '../pages/inbox/inbox_controller.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int)? onTabTapped;
  const CustomBottomNavBar({super.key, this.selectedIndex = 0, this.onTabTapped});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  List navIconList = [Assets.icons.home, Assets.icons.chat];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65 + context.paddingBottom,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,  // Set the background color to white
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.1),  // Light border color (optional)
            width: 1,  // Thin border
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < navIconList.length; i++)
            InkWell(
              onTap: () {
                if (widget.onTabTapped != null) {
                  widget.onTabTapped!(i);
                }
                if (i == 1) {
                  // Get.put(InboxController()).onInit();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  children: [
                    navIconList[i].svg(
                      height: 25.0,
                      color: widget.selectedIndex != i
                          ? Colors.black  // Default black color for unselected icons
                          : Colors.black,  // Selected icon color, adjust as needed
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
