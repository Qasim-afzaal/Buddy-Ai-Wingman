class SendMessageResponse {
  String? id;
  String? conversationId;
  String? senderId;
  String? content;
  String? msgType;
  String? fileUrl;
  String? createdAt;

  SendMessageResponse({this.id, this.conversationId, this.senderId, this.content, this.msgType, this.fileUrl, this.createdAt});

  SendMessageResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'];
    content = json['content'];
    msgType = json['msg_type'];
    fileUrl = json['file_url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['conversation_id'] = conversationId;
    data['sender_id'] = senderId;
    data['content'] = content;
    data['msg_type'] = msgType;
    data['file_url'] = fileUrl;
    data['created_at'] = createdAt;
    return data;
  }
}
