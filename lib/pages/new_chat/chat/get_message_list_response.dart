class GetMessageListResponse {
  int? totalCount;
  String? friendName;
  List<FormattedMessages>? formattedMessages;

  GetMessageListResponse({this.totalCount, this.friendName, this.formattedMessages});

  GetMessageListResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    friendName = json['friendName'];
    if (json['formattedMessages'] != null) {
      formattedMessages = <FormattedMessages>[];
      json['formattedMessages'].forEach((v) {
        formattedMessages!.add(new FormattedMessages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['friendName'] = this.friendName;
    if (this.formattedMessages != null) {
      data['formattedMessages'] = this.formattedMessages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FormattedMessages {
  String? id;
  String? conversationId;
  String? senderId;
  String? content;
  String? fileUrl;
  String? msgType;
  String? createdAt;

  FormattedMessages({this.id, this.conversationId, this.senderId, this.content, this.fileUrl, this.msgType, this.createdAt});

  FormattedMessages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'];
    content = json['content'];
    fileUrl = json['file_url'];
    msgType = json['msg_type'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conversation_id'] = this.conversationId;
    data['sender_id'] = this.senderId;
    data['content'] = this.content;
    data['file_url'] = this.fileUrl;
    data['msg_type'] = this.msgType;
    data['created_at'] = this.createdAt;
    return data;
  }
}
