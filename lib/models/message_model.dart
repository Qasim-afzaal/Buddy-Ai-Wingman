class MessageModel {
  final String? id;
  final String? conversationId;
  final String? senderId;
  final String? content;
  final String? msgType;
  final String? fileUrl;
  final DateTime? createdAt;

  MessageModel({
     this.id,
     this.conversationId,
     this.senderId,
     this.content,
    this.msgType,
    this.fileUrl,
     this.createdAt,
  });

  // Factory method to create an instance from a Map (JSON)
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      conversationId: map['conversation_id'] ?? '',
      senderId: map['sender_id'] ?? '',
      content: map['content'] ?? '',
      msgType: map['msg_type'],
      fileUrl: map['file_url'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
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
      'created_at': createdAt!.toIso8601String(),
    };
  }
}
