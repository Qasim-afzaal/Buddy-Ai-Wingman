// To parse this JSON data, do
//
//     final imageAnalyzerModel = imageAnalyzerModelFromJson(jsonString);

import 'dart:convert';

ImageAnalyzerModel imageAnalyzerModelFromJson(String str) => ImageAnalyzerModel.fromJson(json.decode(str));

String imageAnalyzerModelToJson(ImageAnalyzerModel data) => json.encode(data.toJson());

class ImageAnalyzerModel {
    bool success;
    String message;
    List<Datum> data;

    ImageAnalyzerModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory ImageAnalyzerModel.fromJson(Map<String, dynamic> json) => ImageAnalyzerModel(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? conversationId;
    String? senderId;
    String? content;
    String? msgType;
    String? fileUrl;
    DateTime? createdAt;

    Datum({
         this.id,
         this.conversationId,
         this.senderId,
         this.content,
         this.msgType,
         this.fileUrl,
         this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        conversationId: json["conversation_id"],
        senderId: json["sender_id"],
        content: json["content"],
        msgType: json["msg_type"],
        fileUrl: json["file_url"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "sender_id": senderId,
        "content": content,
        "msg_type": msgType,
        "file_url": fileUrl,
        "created_at": createdAt!.toIso8601String(),
    };
}
