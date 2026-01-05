class GetCoachResponse {
  Conversation? conversation;
  Suggestion? suggestion;
  String? userId;

  GetCoachResponse({this.conversation, this.suggestion, this.userId});

  GetCoachResponse.fromJson(Map<String, dynamic> json) {
    conversation = json['conversation'] != null ? Conversation.fromJson(json['conversation']) : null;
    suggestion = json['suggestion'] != null ? Suggestion.fromJson(json['suggestion']) : null;
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conversation != null) {
      data['conversation'] = conversation!.toJson();
    }
    if (suggestion != null) {
      data['suggestion'] = suggestion!.toJson();
    }
    data['user_id'] = userId;
    return data;
  }
}

class Conversation {
  List<ConversationData>? conversationData;

  Conversation({this.conversationData});

  Conversation.fromJson(Map<String, dynamic> json) {
    if (json['conversation'] != null) {
      conversationData = <ConversationData>[];
      json['conversation'].forEach((v) {
        conversationData!.add(ConversationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conversationData != null) {
      data['conversation'] = conversationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConversationData {
  String? message;
  String? sender;

  ConversationData({this.message, this.sender});

  ConversationData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['sender'] = sender;
    return data;
  }
}

class Suggestion {
  String? flirty;
  String? friendly;
  String? smooth;
  String? street;

  Suggestion({this.flirty, this.friendly, this.smooth, this.street});

  Suggestion.fromJson(Map<String, dynamic> json) {
    flirty = json['Flirty'];
    friendly = json['Friendly'];
    smooth = json['Smooth'];
    street = json['Street'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Flirty'] = flirty;
    data['Friendly'] = friendly;
    data['Smooth'] = smooth;
    data['Street'] = street;
    return data;
  }
}
