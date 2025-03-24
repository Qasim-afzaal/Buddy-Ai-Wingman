class ClearAllChatResponse {
  bool? success;
  String? message;
  List<Data>? data;

  ClearAllChatResponse({this.success, this.message, this.data});

  ClearAllChatResponse.fromJson(Map<String, dynamic> json) {
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
  String? personDetailId;
  bool? isArchive;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.personDetailId, this.isArchive, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personDetailId = json['person_detail_id'];
    isArchive = json['is_archive'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['person_detail_id'] = this.personDetailId;
    data['is_archive'] = this.isArchive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
