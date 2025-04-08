import 'dart:io';

import 'package:flutter/services.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/home/manual_chat/manual_chat_controller.dart';
import 'package:buddy_ai_wingman/pages/home/manual_chat/manual_chat_model.dart';

class ManualChatPage extends StatelessWidget {
  const ManualChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ManualChatPageController chatController =
        Get.put(ManualChatPageController());

    return Scaffold(
      appBar: const SimpleAppBar(title: "Buddy Ai Wingman"),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "What the other person \ntexted?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Obx(() => ListView.builder(
                      controller: chatController.scrollController,
                      itemCount: chatController.messages.length,
                      itemBuilder: (context, index) {
                        final message = chatController.messages[index];
                        return ChatBubble(
                          chatItem: message,
                          currentUserId: chatController.userId ?? "",
                          regenerate:
                              index == chatController.messages.length - 1
                                  ? () {
                                      chatController.sendRegenrateMessage();
                                    }
                                  : null,
                          isLast: index == chatController.messages.length - 1,
                        );
                      },
                    )),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Obx(() => chatController.messages.isNotEmpty &&
                              (chatController.messages[0].conversationId !=
                                      '' &&
                                  chatController.messages[0].conversationId !=
                                      null)
                          ? InkWell(
                              onTap: () {
                                utils.openImagePicker(
                                  context,
                                  onPicked: (pickFile) {
                                    pickFile.forEach((element) async {
                                      chatController.imagePath = element;
                                      chatController.uploadImage();
                                    });
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 12, bottom: 10),
                                child: SvgPicture.asset(
                                  Assets.icons.attachments.path,
                                ),
                              ),
                            )
                          : SizedBox()),

                      // Expanded Text Field
                      Expanded(
                        child: CustomTextField(
                          minLines: 1,
                          fillColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 8,
                          controller: chatController.textController,
                          hintText: AppStrings.enterYourText,
                        ),
                      ),
                      // Send Icon
                      Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            chatController.sendMessage();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.primary,
                            ),
                            child: SvgPicture.asset(
                              Assets.icons.send.path,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Obx(() => chatController.isLoading.value // FIXED
              ? Container(
                  color: Colors.transparent,
                  child: Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    size: 50,
                  )),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Datum chatItem;
  final String currentUserId;
  final VoidCallback? regenerate;
  final bool isLast;

  const ChatBubble({
    super.key,
    required this.chatItem,
    required this.currentUserId,
    this.regenerate,
    required this.isLast,
  });

  String processBulletContent(String content) {
    // Ensure **bold text:** moves to a new line properly
    content = content.replaceAllMapped(
      RegExp(r'(?<!\n)\*\*(.*?)\*\*\s*(:)?'),
      (match) {
        if (match.group(2) != null) {
          // If a colon is present, move the entire bold text + colon to a new line
          return '\n\n**${match.group(1)!}**:\n\n';
        } else {
          // Otherwise, just move bold text to a new line
          return '\n\n**${match.group(1)!}**\n\n';
        }
      },
    );

    content = content.replaceAllMapped(
      RegExp(r'^-(\*\*)', multiLine: true),
      (match) => '• ${match.group(1)!}',
    );

    content = content.replaceAllMapped(
      RegExp(r'^-\s+', multiLine: true),
      (match) => '• ',
    );

    return content;
  }

  @override
  Widget build(BuildContext context) {
    bool isSentByUser = chatItem.senderId == currentUserId;
    print("both id ${chatItem.senderId}.....${currentUserId}");
    print(isSentByUser);
    Widget bubble = Container(
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSentByUser
            ? Colors.black
            : Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isSentByUser ? 16 : 4),
          bottomRight: Radius.circular(isSentByUser ? 4 : 16),
        ),
      ),
      child: chatItem.fileUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: chatItem.fileUrl!.startsWith('https')
                  ? Image.network(
                      chatItem.fileUrl!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: context.primary,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    )
                  : Image.file(
                      File(chatItem.fileUrl!),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
            )
          : (chatItem.content != null
              ? MarkdownBody(
                  data: processBulletContent(chatItem.content!),
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      color: isSentByUser ? Colors.white : Colors.black,
                    ),
                  ),
                )
              : const Icon(Icons.file_present)),
    );

    if (!isSentByUser) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: bubble),
              // Copy icon
              GestureDetector(
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(text: chatItem.content ?? ""),
                  );
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
              // Regenerate icon: only show if this is the last message and the regenerate callback is not null.
              if (isLast && regenerate != null)
                GestureDetector(
                  onTap: regenerate,
                  child: Assets.icons.restartAgain
                      .svg()
                      .paddingAll(8)
                      .marginOnly(bottom: 2),
                ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: bubble,
      ),
    );
  }
}
