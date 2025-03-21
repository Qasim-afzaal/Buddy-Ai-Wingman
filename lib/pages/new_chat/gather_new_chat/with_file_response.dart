class WithFileResponse {
  bool? success;
  String? message;
  List<Data>? data;

  WithFileResponse({this.success, this.message, this.data});

  WithFileResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? conversationId;
  String? senderId;
  String? content;
  String? msgType;
  String? fileUrl;
  String? createdAt;

  Data({this.id, this.conversationId, this.senderId, this.content, this.msgType, this.fileUrl, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'];
    content = json['content'];
    msgType = json['msg_type'];
    fileUrl = json['file_url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conversation_id'] = this.conversationId;
    data['sender_id'] = this.senderId;
    data['content'] = this.content;
    data['msg_type'] = this.msgType;
    data['file_url'] = this.fileUrl;
    data['created_at'] = this.createdAt;
    return data;
  }
}
