import 'package:flutter/services.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<String> randomMessages = const [
    "All the best to both of you, take care and stay happy!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: "Chat Screen"),
      body: Column(
        children: [
          // Centered Image
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Image.asset(
              'assets/images/test.jpg',
              height: 200,
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          // Chat messages - takes up available space
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: randomMessages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: randomMessages[index]);
              },
            ),
          ),

          // Input Section - Stays at the Bottom
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

                  // Text Field (Flexible to avoid overflow)
                  const Expanded(
                    child: CustomTextField(
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
                      onTap: () {
                        // Handle send message logic
                      },
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
            icon: const Icon(
              Icons.copy,
              size: 15,
            ),
            onPressed: () {
              // Add the logic to copy the message
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
