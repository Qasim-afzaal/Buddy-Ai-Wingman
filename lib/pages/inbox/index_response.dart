class IndexResponse {
  bool? success;
  String? message;
  List<IndexResponseData>? data;

  IndexResponse({this.success, this.message, this.data});

  IndexResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <IndexResponseData>[];
      json['data'].forEach((v) {
        data!.add(new IndexResponseData.fromJson(v));
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

class IndexResponseData {
  String? conversationId;
  String? chatType;
  String? name;
  String? createdAt;

  IndexResponseData({this.conversationId, this.chatType, this.name, this.createdAt});

  IndexResponseData.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversation_id'];
    chatType = json['chat_type'];
    name = json['name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversation_id'] = this.conversationId;
    data['chat_type'] = this.chatType;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    return data;
  }
}
