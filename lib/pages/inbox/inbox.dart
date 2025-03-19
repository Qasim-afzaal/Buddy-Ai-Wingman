import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';
import 'package:buddy_ai_wingman/widgets/CustomDropDown.dart';
import 'package:buddy_ai_wingman/widgets/confirmation_widget.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data to replace the controller's inbox list
    List<String> inboxList = ['Test1', 'Test2'];

    return Scaffold(
      appBar: const buddy_ai_wingmanAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Replace Obx with static list of types (if needed, add your own types)
                Row(
                  children: InboxType.values
                      .map(
                        (type) => _InboxType(
                          type: type,
                          onTap: (selectedType, isSelected) {},
                          selectedType: null, // Removed controller reference
                        ),
                      )
                      .toList(),
                ),
                InkWell(
                  onTap: () async {
                    // Check connectivity status before proceeding
                    var connectivityResult =
                        await Connectivity().checkConnectivity();

                    if (connectivityResult != ConnectivityResult.none) {
                      // If internet is available, navigate to the new route
                      Get.toNamed(
                        Routes.GATHER_NEW_CHAT_INFO,
                        arguments: {
                          HttpUtil.isManually: true,
                        },
                      );
                    } else {
                      // No internet connection, show snackbar and stop further execution
                      Get.snackbar(
                        "No Internet",
                        "Please check your internet connection and try again.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: Icon(Icons.abc,color: Colors.white,),
                ),
              ],
            ),
            CustomTextField(
              controller: TextEditingController(), // Removed controller
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  Assets.icons.search.path,
                ),
              ),
              onChange: (query) {
                // Implement search functionality (if needed)
              },
              textInputAction: TextInputAction.search,
              hintText: 'Search',
            ).paddingOnly(top: 20),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 15.0),
                itemBuilder: (context, index) {
                  // Using the dummy inbox list data
                  return _Container(
                    mainData: inboxList[index],
                    index: index,
                  );
                },
                separatorBuilder: (context, index) {
                  return SB.h(15);
                },
                itemCount: inboxList.length,
              ),
            ),
          ],
        ).paddingOnly(
            left: context.paddingDefault,
            right: context.paddingDefault,
            top: context.paddingDefault),
      ),
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({
    super.key,
    required this.mainData,
    required this.index,
  });

  final String mainData;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Check connectivity status before proceeding
        var connectivityResult = await Connectivity().checkConnectivity();

        if (connectivityResult != ConnectivityResult.none) {
          // If internet is available, navigate to the appropriate route
          Get.toNamed(
            Routes.CHAT,
            arguments: {
              HttpUtil.conversationId: index.toString(), // Dummy data for conversationId
              HttpUtil.name: mainData,
              HttpUtil.isManually: false,
            },
          );
        } else {
          // No internet connection, show snackbar and stop further execution
          Get.snackbar(
            "No Internet",
            "Please check your internet connection and try again.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.primary)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                mainData,
                style: context.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CustomDropDown(
                dropDownIcon: const Icon(Icons.more_vert).paddingAll(10),
                onChanged: (data) {
                  if (data?.value == 'Delete') {
                    Get.bottomSheet(ConfirmationWidget(
                      title: AppStrings.deleteChat,
                      description: AppStrings.deleteChatDescription,
                      onConfirmation: () {
                        Get.back();
                        // Handle deletion (no controller, so just placeholder logic)
                      },
                    ));
                  } else if (data?.value == 'Archive') {
                    // Handle archiving (no controller, so just placeholder logic)
                  }
                },
                dropDownList: [] // No dropdown options as per your request
            )
          ],
        ),
      ),
    );
  }
}

class _InboxType extends StatelessWidget {
  const _InboxType({
    super.key,
    required this.type,
    this.selectedType,
    required this.onTap,
  });

  final InboxType type;
  final InboxType? selectedType;
  final Function(InboxType, bool) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(type, true), // Placeholder function
      child: Text(
        type.name,
        style: context.headlineMedium?.copyWith(
          color: selectedType == type ? context.primary : const Color(0xFFA6907F),
          fontWeight: FontWeight.w400,
        ),
      ).paddingAll(10),
    );
  }
}
