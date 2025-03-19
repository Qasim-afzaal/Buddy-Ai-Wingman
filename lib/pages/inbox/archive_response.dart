class ArchiveResponse {
  bool? success;
  String? message;
  ArchiveResponseData? data;

  ArchiveResponse({this.success, this.message, this.data});

  ArchiveResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ArchiveResponseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ArchiveResponseData {
  String? id;
  String? personDetailId;
  bool? isArchive;
  String? createdAt;
  String? updatedAt;

  ArchiveResponseData({this.id, this.personDetailId, this.isArchive, this.createdAt, this.updatedAt});

  ArchiveResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personDetailId = json['person_detail_id'];
    isArchive = json['is_archive'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['person_detail_id'] = personDetailId;
    data['is_archive'] = isArchive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
