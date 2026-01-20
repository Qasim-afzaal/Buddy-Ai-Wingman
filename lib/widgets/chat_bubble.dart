import 'package:buddy/core/constants/imports.dart';

/// Widget for displaying chat bubbles in the conversation view.
/// Currently shows an empty column - implementation to be added when needed.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.chatItem,
    this.regenerate,
    this.disablebutton,
  });

  final String? disablebutton;
  final MessageModel chatItem;
  final void Function()? regenerate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat bubble UI implementation will be added here
      ],
    );
  }
}
