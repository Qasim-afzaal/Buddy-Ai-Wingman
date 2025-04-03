import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:buddy_ai_wingman/core/components/app_image.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({
    super.key,
    required this.chatItem,
    this.regenerate,
    this.disablebutton,
  });

  String? disablebutton = "";
  final MessageModel chatItem;
  void Function()? regenerate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (chatItem.messageType == MessageType.image) ...[
                Center(
                  child: SizedBox(
                    width: 150, // Set the desired image width
                    height: 370, // Set the desired image height
                    child: _Container(chatItem: chatItem),
                  ),
                ),
              ] else if (chatItem.mainText != null) ...[
                Text(
                  chatItem.mainText!,
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                if (chatItem.headline != null)
                  Text(
                    chatItem.headline!,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ).paddingOnly(bottom: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _Container(chatItem: chatItem),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: chatItem.message!));
                        Fluttertoast.showToast(
                          msg: "Copied to clipboard",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                      child: Assets.icons.copy.svg().paddingAll(8),
                    ),
                    if ((chatItem.headline != null || chatItem.isbuddy_ai_wingmanLine) &&
                        (disablebutton == null || disablebutton!.isEmpty)) ...[
                      GestureDetector(
                        onTap: regenerate,
                        child: Assets.icons.restartAgain
                            .svg()
                            .paddingAll(8)
                            .marginOnly(bottom: 2),
                      ),
                    ],
                  ],
                ).paddingOnly(bottom: 15),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({super.key, required this.chatItem});

  final MessageModel chatItem;

  @override
  Widget build(BuildContext context) {
    String message = chatItem.message!;
    if (message.toLowerCase().startsWith('ai dating coach')) {
      message = message.replaceFirst(
          RegExp(r'Ai [dD]ating Coach', caseSensitive: false), 'Dating Coach');
    }

    // Check if the message type is an image
    if (chatItem.messageType == MessageType.image) {
      return chatItem.fileData
          ? AppImage.file(
              file: File(chatItem.message!),
              fit: BoxFit.cover, // Ensures proper scaling
              width: 150, // Specify desired width
              height: 200, // Specify desired height
            )
          : AppImage.network(
              imageUrl: chatItem.message!,
              fit: BoxFit.cover, // Ensures proper scaling
              width: 150, // Specify desired width
              height: 200, // Specify desired height
            );
    }

    // Default container for text messages
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(chatItem.isReceived ? 4 : 16),
          bottomRight: Radius.circular(chatItem.isReceived ? 16 : 4),
        ),
      ),
      child: Text(
        message,
        style: context.bodyLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
