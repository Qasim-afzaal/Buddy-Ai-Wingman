import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:flutter/services.dart';

class SparkdLinesResponsePage extends StatefulWidget {
  const SparkdLinesResponsePage({Key? key}) : super(key: key);

  @override
  State<SparkdLinesResponsePage> createState() =>
      _SparkdLinesResponsePageState();
}

class _SparkdLinesResponsePageState extends State<SparkdLinesResponsePage> {
  final List<String> paragraphs = [
    "For a new date, always have a plan in mind.",
    "Confidence is key—carry yourself with assurance.",
    "A genuine smile can create an unforgettable first impression.",
    "Be curious—ask meaningful questions and listen actively.",
    "Humor can lighten the mood and make the date enjoyable."
  ];

  int currentIndex = 0;

  void _updateText() {
    setState(() {
      currentIndex = (currentIndex + 1) % paragraphs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const SimpleAppBar(
        title: "Dating Coach",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Adjust height dynamically based on screen height
          SizedBox(height: screenHeight * 0.25), // Adjust this value as needed

          // Use Expanded to allow ListView to take available space above the button
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.6), // Adjust this value as needed
              child: ListView(
                shrinkWrap: true,
                children: [
                  ChatBubble(
                    message: paragraphs[currentIndex],
                    disableButton: false,
                    onRegenerate: _updateText,
                  ),
                ],
              ),
            ),
          ),

          // Align the button at the bottom of the screen
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: AppButton.primary(
                title: AppStrings.giveMeLine,
                onPressed: _updateText,
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
