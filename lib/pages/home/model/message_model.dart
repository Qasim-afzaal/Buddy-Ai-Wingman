class MessageModelPickup {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final String? msgType;
  final String? fileUrl;
  final DateTime createdAt;

  MessageModelPickup({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.msgType,
    this.fileUrl,
    required this.createdAt,
  });

  // Factory method to create an instance from a Map (JSON)
  factory MessageModelPickup.fromMap(Map<String, dynamic> map) {
    return MessageModelPickup(
      id: map['id'],
      conversationId: map['conversation_id'],
      senderId: map['sender_id'],
      content: map['content'],
      msgType: map['msg_type'],
      fileUrl: map['file_url'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Convert an instance to a Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'msg_type': msgType,
      'file_url': fileUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
