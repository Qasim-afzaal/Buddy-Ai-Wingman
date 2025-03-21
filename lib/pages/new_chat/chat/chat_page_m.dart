import 'package:flutter/services.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';

class ChatPage2 extends StatefulWidget {
  const ChatPage2({Key? key}) : super(key: key);

  @override
  State<ChatPage2> createState() => _ChatPage2State();
}

class _ChatPage2State extends State<ChatPage2> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = false; // Loader state

  void sendMessage() async {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"message": text, "isSender": true});
      _messageController.clear();
      isLoading = true; // Show loader
    });

    // Simulate a delay for the receiver's response
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false; // Hide loader
      messages.add({
        "message": "Sounds perfect. Let’s make it a date to remember. What time works for you?",
        "isSender": false,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: "Chat Screen"),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (isLoading && index == messages.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final messageData = messages[index];
                return ChatBubble(
                  message: messageData["message"],
                  isSender: messageData["isSender"],
                );
              },
            ),
          ),

          // Input section
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  // Attachment Icon
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: SvgPicture.asset(Assets.icons.attachments.path),
                  ),

                  // Text Field
                  Expanded(
                    child: CustomTextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      hintText: AppStrings.enterYourText,
                    ),
                  ),

                  // Send Button
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.primary,
                        ),
                        child: SvgPicture.asset(Assets.icons.send.path),
                      ),
                    ),
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

// ChatBubble widget
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const ChatBubble({Key? key, required this.message, required this.isSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender)
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min, // Prevents excessive width
                children: [
                  // Receiver's chat bubble
                  Flexible(
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
                  const SizedBox(width: 5), // Add some spacing
                  // Copy icon
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
            ),
          if (isSender)
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
