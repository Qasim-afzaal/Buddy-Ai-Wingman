class DeleteResponse {
  bool? success;
  String? message;
  DeleteResponseData? data;

  DeleteResponse({this.success, this.message, this.data});

  DeleteResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new DeleteResponseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DeleteResponseData {
  String? id;
  String? personDetailId;
  bool? isArchive;
  String? createdAt;
  String? updatedAt;

  DeleteResponseData({this.id, this.personDetailId, this.isArchive, this.createdAt, this.updatedAt});

  DeleteResponseData.fromJson(Map<String, dynamic> json) {
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
