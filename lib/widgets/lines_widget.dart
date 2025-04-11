import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/models/error_response.dart';
import 'package:buddy_ai_wingman/pages/home/home_controller.dart';
import 'package:buddy_ai_wingman/pages/new_chat/gather_new_chat/spark_line_response.dart';

import '../routes/app_pages.dart';

class LinesWidget extends StatefulWidget {
  const LinesWidget({
    super.key,
    required this.data,
    this.showCloseIcon = false,
    this.enableTap = true,
  });

  final SparkLinesModel data;
  final bool showCloseIcon;
  final bool enableTap;

  @override
  State<LinesWidget> createState() => _LinesWidgetState();
}

class _LinesWidgetState extends State<LinesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey[100],
        border: Border.all(
          color: context.primary,
        ),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () {
          Get.toNamed(Routes.SPARKD_LINES_RESPONSE);
          // arguments: {
          //   HttpUtil.conversationId: mainModel.data?[0].conversationId,
          //   HttpUtil.message: message,
          //   HttpUtil.name: "",
          //   HttpUtil.previousSuggestions: []
          // },
        },
        // onTap: widget.enableTap
        //     ? () async {
        //         // Check connectivity status before proceeding
        //         var connectivityResult =
        //             await Connectivity().checkConnectivity();

        //         // Print the result for debugging
        //         print('Connectivity Result: $connectivityResult');

        //         if (connectivityResult != ConnectivityResult.none) {
        //           // If internet is available, handle the message
        //         await handleMessage(widget.data.text);
        //         } else {
        //           // No internet connection, show snackbar and stop further execution
        //           Get.snackbar(
        //             "No Internet",
        //             "Please check your internet connection and try again.",
        //             snackPosition: SnackPosition.BOTTOM,
        //           );
        //           return; // Prevent further execution if no internet
        //         }
        //       }
        //     : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset(
            //   data.iconPath,
            //   height: 32,
            //   width: 32,
            // ),
            SB.w(8),
            Text(
              widget.data.text.length > 26
                  ? widget.data.text.substring(0, 26) + '...'
                  : widget.data.text,
              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),

            if (widget.showCloseIcon) ...[
              SB.w(8),
              Icon(Icons.close),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> handleMessage(String? message) async {
    print("this is msg$message");
    if (message != null) {
      var json = {
        HttpUtil.conversationId: "",
        HttpUtil.messageId: "",
        HttpUtil.message: message,
        HttpUtil.name: "",
        HttpUtil.objective: "",
        HttpUtil.gender: "",
        HttpUtil.age: "",
        HttpUtil.personalityType: "",
        HttpUtil.previousSuggestions: []
      };

      print("this is data$json");

      final data = await APIFunction().patchApiCall(
        apiName: Constants.buddy_ai_wingmanLines,
        withOutFormData: jsonEncode(json),
      );

      try {
        SparkLineResponse mainModel = SparkLineResponse.fromJson(data);
        if (mainModel.success!) {
          Get.toNamed(
            Routes.SPARKD_LINES_RESPONSE,
            arguments: {
              HttpUtil.conversationId: mainModel.data?[0].conversationId,
              HttpUtil.message: message,
              HttpUtil.name: "",
              HttpUtil.previousSuggestions: []
            },
          );
          setState(() {});
        } else {
          utils.showToast(message: mainModel.message!);
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);
        utils.showToast(message: errorModel.message!);
      }
    }
  }
}
