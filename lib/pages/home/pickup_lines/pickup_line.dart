import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:buddy/core/constants/imports.dart';

import 'pickup_line_controller.dart';

class PickupLinePage extends StatelessWidget {
  const PickupLinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PickupLineController controller =
        Get.put(PickupLineController()); // Put controller globally
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: SimpleAppBar(
        title: "Buddy Ai Wingman",
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Origineel zijn scoort.\nTik op 'Give me more', Buddy blijft nieuwe openingszinnen bedenken tot je de perfecte hebt.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Expanded(
                child: Obx(() => ListView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];
                        return ChatBubble(
                          message: message.content,
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

  void _handleReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Report Message"),
        content:
            const Text("Do you want to report this AI-generated response?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Message reported to the team"),
                  backgroundColor: Colors.redAccent,
                ),
              );
              debugPrint("Reported message: $message");
            },
            child: const Text("Report"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onLongPress: () => _handleReport(context),
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
