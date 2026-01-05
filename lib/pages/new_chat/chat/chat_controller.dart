import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:buddy/api_repository/api_class.dart';
import 'package:buddy/api_repository/loading.dart';
import 'package:buddy/core/constants/helper.dart';
import 'package:buddy/models/file_upload_response.dart';
import 'package:buddy/pages/new_chat/chat/error_response.dart';
import 'package:buddy/pages/new_chat/chat/get_message_list_response.dart';
import 'package:buddy/pages/new_chat/chat/send_message_response.dart';

import '../../../api_repository/api_function.dart';
import '../../../core/constants/imports.dart';

class ChatController extends GetxController {
  RxBool isRecording = false.obs;
  String? imagePath;
  String fileType = "";
  RxBool isLoading = false.obs;
  int pageSize = 10;
  RxInt totalItems = 0.obs;
  TextEditingController textController = TextEditingController();
  final scrollController = ScrollController();
  List<MessageModel> chatList = [];
  String? conversationId;
  String? name;
  int indexRegenerate = 0;
  bool isManually = false;
  String? objective, gender, age, personalityType;

  @override
  void onInit() {
    if (Get.arguments != null) {
      conversationId = Get.arguments[HttpUtil.conversationId];
      name = Get.arguments[HttpUtil.name];
      isManually = Get.arguments[HttpUtil.isManually];
      print("this is chat data$isManually");
      objective = Get.arguments[HttpUtil.objective];
      gender = Get.arguments[HttpUtil.gender];
      age = Get.arguments[HttpUtil.age];
      personalityType = Get.arguments[HttpUtil.personalityType];
    }
    getMessageResponse();
    if (isManually) {
      var data = {
        HttpUtil.userId: getStorageData.readString(getStorageData.userIdKey),
        HttpUtil.name: name,
        HttpUtil.objective: objective,
        HttpUtil.gender: gender,
        HttpUtil.age: age,
        HttpUtil.personalityType: personalityType,
      };
      Map chatmsg = {
        "name": "${HttpUtil.email ?? ""} Manual Chat chat  list getting"
      };
      Constants.socket!.emit("logEvent", chatmsg);
      printAction(
          "<<< ======= Log Socket manualChat emit ======= >>> ${jsonEncode(data)}");
      Constants.socket!.emit(Constants.manualChat, data);
      Loading.show();
      update();
    } else {
      getMessageList(pageSize);
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoading.value) {
        loadMore();
      }
    });
    super.onInit();
  }

  getMessageResponse() {
    Constants.socket!.on(
      Constants.receiveConversation,
      (data) {
        printOkStatus(
            "<<< ======= Log Socket receiveConversation Response ======= >>> ${jsonEncode(data)}");
        Map msg = {"name": "Chat Screen"};
        Constants.socket!.emit("logEvent", msg);
        GetMessageListResponse sendMessageResponse =
            GetMessageListResponse.fromJson(data);
        List<MessageModel> list = [];
        // for (int i = 0;
        //     i < sendMessageResponse.formattedMessages!.length;
        //     i++) {
        //   list.add(MessageModel(
        //       message:
        //           sendMessageResponse.formattedMessages![i].msgType == "title"
        //               ? null
        //               : sendMessageResponse.formattedMessages![i].msgType ==
        //                       "Extracted-Data"
        //                   ? sendMessageResponse.formattedMessages![i].fileUrl!
        //                   : sendMessageResponse.formattedMessages![i].content!,
        //       messageType: sendMessageResponse.formattedMessages![i].msgType ==
        //               "Extracted-Data"
        //           ? MessageType.image
        //           : MessageType.text,
        //       isReceived: sendMessageResponse.formattedMessages![i].senderId !=
        //           getStorageData.readString(getStorageData.userIdKey),
        //       headline: sendMessageResponse.formattedMessages![i].msgType ==
        //               "Extracted-Data"
        //           ? null
        //           : sendMessageResponse.formattedMessages![i].msgType,
        //       messageId: sendMessageResponse.formattedMessages![i].id!,
        //       mainText:
        //           sendMessageResponse.formattedMessages![i].msgType == "title"
        //               ? sendMessageResponse.formattedMessages![i].content!
        //               : null));
        // }
        // chatList.insertAll(0, list);
        totalItems.value = sendMessageResponse.totalCount!;
        isLoading.value = false;
        update();
      },
    );
    Constants.socket!.on(
      Constants.receiveMessage,
      (data) {
        printOkStatus(
            "<<< ======= Log Socket receiveConversation Response ======= >>> ${jsonEncode(data)}");
        List<SendMessageResponse> sendMessageResponse = [];
        sendMessageResponse.addAll((data as List<dynamic>)
            .map((json) => SendMessageResponse.fromJson(json)));
        // for (var list in sendMessageResponse) {
        //   chatList.add(
        //     MessageModel(
        //       message: list.content!,
        //       messageType: MessageType.text,
        //       isReceived: true,
        //       messageId: list.id!,
        //       headline: list.msgType,
        //     ),
        //   );
        //   Loading.dismiss();
        //   update();
        // }
      },
    );
    Constants.socket!.on(
      Constants.suggestion,
      (data) {
        printOkStatus(
            "<<< ======= Log Socket suggestion Response ======= >>> ${jsonEncode(data)}");
        List<SendMessageResponse> sendMessageResponse = [];
        sendMessageResponse.addAll((data as List<dynamic>)
            .map((json) => SendMessageResponse.fromJson(json)));
        // for (var list in sendMessageResponse) {
        //   chatList[indexRegenerate] = MessageModel(
        //     message: list.content!,
        //     messageType: MessageType.text,
        //     isReceived: true,
        //     messageId: list.id!,
        //     headline: list.msgType,
        //   );
        //   Loading.dismiss();
        //   update();
        // }
      },
    );

    Constants.socket!.on(
      Constants.message,
      (data) {
        printOkStatus(
            "<<< ======= Log Socket message Response ======= >>> ${jsonEncode(data)}");
        List<SendMessageResponse> sendMessageResponse = [];
        sendMessageResponse.addAll((data as List<dynamic>)
            .map((json) => SendMessageResponse.fromJson(json)));
        // for (var list in sendMessageResponse) {
        //   conversationId = list.conversationId;
        //   chatList.add(MessageModel(
        //     mainText: list.content!,
        //     messageType: MessageType.text,
        //     isReceived: true,
        //     messageId: list.id!,
        //     headline: list.msgType,
        //     message: '',
        //   ));
        //   Loading.dismiss();
        //   update();
        // }
      },
    );
    Constants.socket!.on(
      Constants.error,
      (data) {
        printError(
            "<<< ======= Log Socket Error Response ======= >>> ${jsonEncode(data)}");
        Loading.dismiss();
        ErrorResponse errorResponse = ErrorResponse.fromJson(data);
        utils.showToast(message: errorResponse.message!);
      },
    );
  }

  sendMessage(String? content, String? fileData) {
    var data = {
      HttpUtil.userId: getStorageData.readString(getStorageData.userIdKey),
      HttpUtil.conversationId: conversationId,
      HttpUtil.content: content,
      HttpUtil.fileData: fileData,
    };
    Map chatmsg = {"name": "Send msg Chat"};
    Constants.socket!.emit("logEvent", chatmsg);
    printAction(
        "<<< ======= Log Socket sendMessage emit ======= >>> ${jsonEncode(data)}");
    Constants.socket!.emit(Constants.sendMessage, data);
    Loading.show();
    update();
  }

  getMessageList(int pageSize) {
    isLoading.value = true;
    var data = {
      HttpUtil.conversationId: conversationId,
      HttpUtil.skip: chatList.length,
      HttpUtil.size: pageSize.toString(),
    };
    printAction(
        "<<< ======= Log Socket getConversationDetail emit ======= >>> ${jsonEncode(data)}");
    Constants.socket!.emit(Constants.getConversationDetail, data);
    Map chatmsg = {"name": "all list msgs"};
    Constants.socket!.emit("logEvent", chatmsg);
    update();
  }

  regenerateMessage(MessageModel tempList) {
    // indexRegenerate =
    //     chatList.indexWhere((item) => item.messageId == tempList.messageId);
    print("this is index of regenrate data$indexRegenerate");
    // var data = {
    //   HttpUtil.userId: getStorageData.readString(getStorageData.userIdKey),
    //   HttpUtil.conversationId: conversationId,
    //   HttpUtil.messageId: tempList.messageId,
    //   HttpUtil.content: tempList.headline ?? "Smooth",
    // };
    // printAction(
    // "<<< ======= Log Socket getSuggestionAgain emit ======= >>> ${jsonEncode("data")}");
    Constants.socket!.emit(Constants.getSuggestionAgain, "data");
    Loading.show();
    update();
  }

  void loadMore() {
    if (!isLoading.value && chatList.length < totalItems.value) {
      getMessageList(pageSize);
    }
  }

  @override
  void onClose() {
    Constants.socket?.off(Constants.receiveMessage);
    Constants.socket?.off(Constants.receiveConversation);
    Constants.socket?.off(Constants.suggestion);
    Constants.socket?.off(Constants.message);
    Constants.socket?.off(Constants.error);
    super.onClose();
  }

  uploadImage() async {
    FormData formData = FormData();
    printAction("imagePath >>>>>>>>>>> $imagePath");
    if (imagePath != null) {
      formData.files.add(MapEntry(
          HttpUtil.profileImageUrl,
          MultipartFile.fromFileSync(
            imagePath!,
            filename: imagePath!.split("/").last,
          )));
    }
    final data = await APIFunction().patchApiCall(
      apiName: Constants.uploadFile,
      data: formData,
    );
    try {
      // Check if response is an error (has statusCode field)
      if (data is Map<String, dynamic> && data.containsKey('statusCode')) {
        // This is an error response
        final errorMessage = data['message'] ?? 'Upload failed';
        utils.showToast(message: errorMessage);
        return;
      }

      FileUploadResponse model = FileUploadResponse.fromJson(data);
      if (model.success!) {
        // chatList.add(
        //   MessageModel(
        //     message: imagePath,
        //     fileData: true,
        //     messageType: MessageType.image,
        //     isReceived: false,
        //     messageId: "",
        //   ),
        // );
        Loading.show();
        update();
        sendMessage("", model.data);
      } else {
        utils.showToast(message: model.message ?? 'Upload failed');
      }
    } catch (e) {
      // Try to extract error message
      String errorMessage = "Upload failed";
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        errorMessage = data['message'] ?? errorMessage;
      } else {
        try {
          ErrorResponse errorModel = ErrorResponse.fromJson(data);
          errorMessage = errorModel.message ?? errorMessage;
        } catch (_) {}
      }
      utils.showToast(message: errorMessage);
    }
  }

  void onRecordingChange() {
    isRecording.value = !isRecording.value;
  }
}
