class ErrorResponse {
  int? statusCode;
  String? message;

  ErrorResponse({
    this.statusCode,
    this.message,
  });

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'] ?? 0;
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = statusCode;
    data['message'] = message;
    return data;
  }
}
