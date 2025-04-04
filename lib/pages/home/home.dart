import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:buddy_ai_wingman/core/components/custom_button2.dart';
import 'package:buddy_ai_wingman/core/constants/app_colors.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/home/home_controller.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';
import 'package:buddy_ai_wingman/widgets/lines_widget.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isDisposed = false;

  String? imagePath;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyReviewed();
  
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _checkIfAlreadyReviewed() async {
    if (!_isDisposed) {
      setState(() {
      });
    }
  }




  Future<void> _handleImagePicker() async {
    // var connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult != ConnectivityResult.none) {
      utils.openImagePicker(
        context,
        onPicked: (pickFile) {
          setState(() {
            imagePath = pickFile.first;
          });
          Get.toNamed(Routes.GATHER_NEW_CHAT_INFO);
        },
      );
    // } else {
    //   Get.snackbar(
    //     "No Internet",
    //     "Please check your internet connection and try again.",
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // }
  }

  void _addNewChatManually(bool isManual) {
    // Your logic for adding a new chat manually
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    int itemsPerRow = _getItemsPerRow(screenHeight);
 
    return Scaffold(
      appBar: const  buddy_ai_wingmanAppBarBeforePayment(),
      body: SafeArea(
        child: Column(
          children: [
            SB.h(context.height * 0.02),
            Text("Upload a screen shot\n of a chat or bio",
                textAlign: TextAlign.center,
                style: GoogleFonts.interTight(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                )),
            SB.h(20),
            Container(
              height: context.height * 0.28,
              width: 200,
              decoration: BoxDecoration(
                // color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/back.png"), // Use AssetImage here
                  fit: BoxFit.cover,
                  opacity: 0.5,
                ),
              ),
            ),
            SB.h(context.height * 0.12),
            SB.h(20),
            AppButton.primary(
              title: "Upload a screenshot",
              onPressed: () {
                _handleImagePicker();
              },
            ).paddingSymmetric(
              // horizontal: context.width * 0.15,
              vertical: 10,
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: CustomButton2(
                    onTap: () => Get.toNamed(Routes.NEW),
                    buttonText: 'Manual Chat',
                  backGroundColor: AppColors.fieldBackgroundColor,
                    textColor: AppColors.blackColor,
                  ),
                ),
                const SizedBox(width: 10),
                // Done Button
                Expanded(
                  child: CustomButton2(
                    onTap: () {
                      Get.toNamed(Routes.buddy_ai_wingman_LINES_RESPONSE);
                    },
                    // onTap: () =>   controller.codeVerification(),
                    buttonText: 'Get Pickup Lines',
                    backGroundColor: AppColors.fieldBackgroundColor,
                  
                    textColor: AppColors.blackColor,
                  ),
                ),
              ],
            ),
            SB.h(10),
          ],
        ).paddingAll(context.paddingDefault),
      ),
    );
  }

  int _getItemsPerRow(double screenHeight) {
    if (screenHeight >= 600 && screenHeight <= 776) {
      return 17;
    } else if (screenHeight >= 932 && screenHeight <= 1000) {
      return Platform.isIOS ? 10 : 10;
    } else if (screenHeight >= 926 && screenHeight <= 940) {
      return Platform.isIOS ? 10 : 12;
    } else if (screenHeight >= 800 && screenHeight <= 940) {
      return Platform.isIOS ? 14 : 12;
    } else if (screenHeight >= 826 && screenHeight < 850) {
      return 12;
    } else {
      return 14;
    }
  }

  List<Widget> _buildRows(List<SparkLinesModel> linesList, int itemsPerRow) {
    List<Widget> rows = [];
    for (int i = 0; i < linesList.length; i += itemsPerRow) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < itemsPerRow; j++) {
        final index = i + j;
        if (index < linesList.length) {
          rowChildren.add(LinesWidget(data: linesList[index]));
        } else {
          rowChildren.add(SizedBox.shrink());
        }
      }

      if (i + itemsPerRow >= linesList.length) {
        rowChildren =
            rowChildren.takeWhile((element) => element is! SizedBox).toList();
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren,
          ),
        );
      } else {
        rows.add(Row(children: rowChildren));
      }
    }
    return rows;
  }
}
