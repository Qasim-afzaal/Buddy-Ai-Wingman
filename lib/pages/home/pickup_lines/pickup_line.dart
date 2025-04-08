import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:buddy_ai_wingman/core/constants/imports.dart';

import 'pickup_line_controller.dart';

class PickupLinePage extends StatelessWidget {
  const PickupLinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PickupLineController controller =
        Get.put(PickupLineController()); // Put controller globally
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const SimpleAppBar(title: "Buddy Ai Wingman"),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.25),
              Expanded(
                child: Obx(() => ListView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.messages?.length ?? 0,
                      itemBuilder: (context, index) {
                        final message = controller.messages![index];
                        return ChatBubble(
                          message: message.content ?? '', // Ensure safe access
                          disableButton: false,
                          onRegenerate: () {},
                        );
                      },
                    )),
              ),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Obx(() => AppButton.primary(
                        title: controller.isLoading.value
                            ? "Loading..."
                            : AppStrings.giveMeLine,
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.startChat,
                      )),
                ),
              ),
            ],
          ),
          // Full-screen loader
          Obx(() => controller.isLoading.value
              ? Container(
                  color: Colors.transparent,
                  child: Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.black,
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
  final String message;
  final bool disableButton;
  final VoidCallback? onRegenerate;

  const ChatBubble({
    Key? key,
    required this.message,
    this.disableButton = false,
    this.onRegenerate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 15),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message copied!')),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
