import 'package:buddy_ai_wingman/core/enums/chat_type.dart';

class MessageModel {
  final String? message;
  final String messageId;
  final String? headline;
  final String? mainText;
  final MessageType messageType;
  final bool isReceived;
  final bool fileData;
  final bool isbuddy_ai_wingmanLine;

  MessageModel({
    this.headline,
    this.mainText,
    this.fileData = false,
    this.isbuddy_ai_wingmanLine = false,
    required this.message,
    required this.messageId,
    required this.messageType,
    required this.isReceived,
  });
}
