import 'dart:convert';

import 'package:buddy_ai_wingman/core/constants/imports.dart';

import '../../../api_repository/api_class.dart';
import '../../../api_repository/api_function.dart';
import '../../../api_repository/loading.dart';
import '../../../core/constants/helper.dart';
import '../../../models/error_response.dart';
import '../../home/home_controller.dart';
import '../../new_chat/chat/get_message_list_response.dart';
import '../../new_chat/gather_new_chat/spark_line_regenrate_response.dart';

class SparkdLinesResponseController extends GetxController {
  List<MessageModel> chatList = [];
  SparkLinesModel? message;
  String? name, conversationId;
  String? storeId;
  String? msgName;
  RxBool isLoading = false.obs;
  RxBool isRequest = false.obs;
  RxBool isFetching = false.obs;
  int pageSize = 20;
  RxInt totalItems = 0.obs;
  RxBool fetchRequest = false.obs;
  int indexRegenerate = 0;
  final scrollController = ScrollController();
  String? preFetchedMessageId;
  SparkLineRegenerateResponse? preFetchedMessage;
  List<String> storeList = [];

  // void updateBool(RxBool request) {
  //   isRequest.obs = request;
  // }

  // @override
  // void onInit() {
  //   storeList.clear();
  //   getMessageResponse();
  //   if (Get.arguments != null) {
  //     conversationId = Get.arguments[HttpUtil.conversationId];
  //     msgName = Get.arguments[HttpUtil.message];
  //     print("this is msg name $msgName");
  //     getMessageList(pageSize);

  //     // Prefetch the message when the screen is loaded
  //     prefetchMessage(nameTitle: msgName);
  //   }

  //   scrollController.addListener(() {
  //     if (scrollController.position.pixels ==
  //             scrollController.position.maxScrollExtent &&
  //         !isLoading.value) {
  //       loadMore();
  //     }
  //   });
  //   super.onInit();
  // }

  void loadMore() {
    if (!isLoading.value && chatList.length < totalItems.value) {
      getMessageList(pageSize);
    }
  }

  getMessageList(int pageSize) {
    isLoading.value = true;
    var data = {
      HttpUtil.conversationId: conversationId,
      HttpUtil.skip: chatList.length * 2,
      HttpUtil.size: pageSize.toString(),
    };
    printAction(
        "<<< ======= Log Socket getConversationDetail emit ======= >>> ${jsonEncode(data)}");
    Constants.socket!.emit(Constants.getConversationDetail, data);
    update();
  }

  getMessageResponse() {
    Constants.socket!.on(
      Constants.receiveConversation,
      (data) {
        printOkStatus(
            "<<< ======= Log Socket receiveConversation Response ======= >>> ${jsonEncode(data)}");
        GetMessageListResponse sendMessageResponse =
            GetMessageListResponse.fromJson(data);
        print("this is  datatata...${data["formattedMessages"][1]["content"]}");
        storeList.add(jsonEncode(data["formattedMessages"][1]["content"]));
        print("this is  storeList...$storeList");
        List<MessageModel> list = [];
        for (int i = 0;
            i < sendMessageResponse.formattedMessages!.length;
            i++) {
          if (sendMessageResponse.formattedMessages![i].senderId !=
              getStorageData.readString(getStorageData.userIdKey)) {
            // list.add(MessageModel(
            //   message: sendMessageResponse.formattedMessages![i].content!,
            //   messageType: MessageType.text,
            //   isReceived: true,
            //   headline: null,
            //   messageId: sendMessageResponse.formattedMessages![i].id!,
            //   isSparkdLine: true,
            //   mainText: null,
            // ));
          } else {
            if (message == null) {
              for (int j = 0; j < linesList.length; j++) {
                if (sendMessageResponse.formattedMessages![i].content ==
                    linesList[j].text) {
                  message = linesList[j];
                }
              }
            }
          }
        }
        chatList.insertAll(0, list);
        totalItems.value = sendMessageResponse.totalCount! ~/ 2;
        isLoading.value = false;
        update();
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

  Future<void> prefetchMessage(
      {String messageId = "", String? nameTitle}) async {
    preFetchedMessageId = "";
    print("this is nameTitle$nameTitle");
    var json = {
      HttpUtil.conversationId: conversationId,
      HttpUtil.messageId: preFetchedMessageId,
      HttpUtil.message: nameTitle,
      HttpUtil.name: name,
      HttpUtil.objective: "",
      HttpUtil.gender: "",
      HttpUtil.age: "",
      HttpUtil.personalityType: "",
      HttpUtil.previousSuggestions: storeList,
    };
    print("json bodyprint $json");
    final data = await APIFunction().patchApiCall2(
      apiName: Constants.buddy_ai_wingmanLines,
      withOutFormData: jsonEncode(json),
    );
    print("data is here ${data["data"]["content"]}");
    storeList.add(jsonEncode(data["data"]["content"]));

    try {
      preFetchedMessage = SparkLineRegenerateResponse.fromJson(data);

      // If the user has clicked the button while the API is fetching, update the chat immediately
      // if (fetchRequest.value) {
      //   showPrefetchedMessage();
      // }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      isFetching.value = false; //
      utils.showToast(message: errorModel.message!);
    } finally {
      // isFetching.value =
      //     false; // Reset the fetching flag after API call finishes
    }
  }

  // Handle button click: Add data immediately if available or run API in the background
  void showPrefetchedMessage() async {
    if (preFetchedMessage != null && preFetchedMessage!.success!) {
      // Always update the message at index 0
      if (chatList.isNotEmpty) {
        // chatList[0] = MessageModel(
        //   messageType: MessageType.text,
        //   message: preFetchedMessage!.data?.content ?? "",
        //   isReceived: true,
        //   messageId: preFetchedMessage!.data?.id ?? "",
        //   isSparkdLine: true,
        // );
      } else {
        print("i am add");
        // If chatList is empty, add the first item
        // chatList.add(MessageModel(
        //   messageType: MessageType.text,
        //   message: preFetchedMessage!.data?.content ?? "",
        //   isReceived: true,
        //   messageId: preFetchedMessage!.data?.id ?? "",
        //   isSparkdLine: true,
        // ));
      }
      isFetching.value = false;
      update();
      preFetchedMessage = null;
      // Prefetch the next message silently in the background
      prefetchMessage();
    } else {
      // If no prefetched data available, show loader and fetch new message
      fetchNewMessage();
    }
  }

  // Fetch new message and show loader if necessary
  void fetchNewMessage() async {
    fetchRequest.value = true; // Indicate user-initiated fetch
    isFetching.value = true; // Show loader

    var json = {
      HttpUtil.conversationId: conversationId,
      HttpUtil.messageId: "",
      HttpUtil.message: message?.text ?? "",
      HttpUtil.name: name,
      HttpUtil.objective: "",
      HttpUtil.gender: "",
      HttpUtil.age: "",
      HttpUtil.personalityType: "",
      HttpUtil.previousSuggestions: storeList,
    };

    final data = await APIFunction().patchApiCall2(
      apiName: Constants.buddy_ai_wingmanLines,
      withOutFormData: jsonEncode(json),
    );

    try {
      SparkLineRegenerateResponse newMessage =
          SparkLineRegenerateResponse.fromJson(data);

      if (newMessage.success!) {
        // Always update the indexRegenerate position
        if (indexRegenerate < chatList.length) {
          // chatList[indexRegenerate] = MessageModel(
          //   messageType: MessageType.text,
          //   message: newMessage.data?.content ?? "",
          //   isReceived: true,
          //   messageId: newMessage.data?.id ?? "",
          //   isSparkdLine: true,
          // );
        }
        update();
      } else {
        utils.showToast(
            message: newMessage.message ?? "Error fetching new message");
      }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    } finally {
      isFetching.value = false; // Hide loader
      fetchRequest.value = false; // Reset user request flag
    }
  }

  getMeLineStore({String messageId = ""}) async {
    if (isFetching.value) {
      utils.showToast(message: "Data is being updated, please wait.");
      return; // Block new request if API call is in progress
    }
    isFetching.value =
        true; // Set the flag to indicate that API call is in progress

    var json = {
      HttpUtil.conversationId: conversationId,
      HttpUtil.messageId: messageId,
      HttpUtil.message: message?.text ?? "",
      HttpUtil.name: name,
      HttpUtil.objective: "",
      HttpUtil.gender: "",
      HttpUtil.age: "",
      HttpUtil.personalityType: "",
    };

    final data = await APIFunction().patchApiCall2(
      apiName: Constants.buddy_ai_wingmanLines,
      withOutFormData: jsonEncode(json),
    );
    try {
      SparkLineRegenerateResponse mainModel =
          SparkLineRegenerateResponse.fromJson(data);
      storeId = messageId;
      chatUpdate(mainModel, messageId);
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    } finally {
      isFetching.value = false;
    }
  }

  void chatUpdate(SparkLineRegenerateResponse mainModel, String messageId) {
    // if (mainModel.success!) {
    //   if (messageId != "") {
    //     indexRegenerate =
    //         chatList.indexWhere((item) => item.messageId == messageId);
    //     chatList[indexRegenerate] = MessageModel(
    //       messageType: MessageType.text,
    //       message: mainModel.data?.content ?? "",
    //       isReceived: true,
    //       messageId: mainModel.data?.id ?? "",
    //       isSparkdLine: true,
    //       headline: null,
    //       mainText: null,
    //     );
    //     update();
    //   } else {
    //     chatList.add(MessageModel(
    //       messageType: MessageType.text,
    //       message: mainModel.data?.content ?? "",
    //       isReceived: true,
    //       messageId: mainModel.data?.id ?? "",
    //       isSparkdLine: true,
    //       headline: null,
    //       mainText: null,
    //     ));
    //     update();
    //   }
    // } else {
    //   utils.showToast(message: mainModel.message!);
    // }
  }

  getMeLine({String messageId = ""}) async {
    var json = {
      HttpUtil.conversationId: conversationId,
      HttpUtil.messageId: messageId,
      HttpUtil.message: message?.text ?? "",
      HttpUtil.name: name,
      HttpUtil.objective: "",
      HttpUtil.gender: "",
      HttpUtil.age: "",
      HttpUtil.personalityType: "",
    };
    final data = await APIFunction().patchApiCall(
      apiName: Constants.buddy_ai_wingmanLines,
      withOutFormData: jsonEncode(json),
    );
    try {
      SparkLineRegenerateResponse mainModel =
          SparkLineRegenerateResponse.fromJson(data);
      // if (mainModel.success!) {
      //   if (messageId != "") {
      //     indexRegenerate =
      //         chatList.indexWhere((item) => item.messageId == messageId);
      //     chatList[indexRegenerate] = MessageModel(
      //       messageType: MessageType.text,
      //       message: mainModel.data?.content ?? "",
      //       isReceived: true,
      //       messageId: mainModel.data?.id ?? "",
      //       isSparkdLine: true,
      //       headline: null,
      //       mainText: null,
      //     );
      //     update();
      //   } else {
      //     chatList.add(MessageModel(
      //       messageType: MessageType.text,
      //       message: mainModel.data?.content ?? "",
      //       isReceived: true,
      //       messageId: mainModel.data?.id ?? "",
      //       isSparkdLine: true,
      //       headline: null,
      //       mainText: null,
      //     ));
      //     update();
      //   }
      // } else {
      //   utils.showToast(message: mainModel.message!);
      // }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    }
  }

  @override
  void onClose() {
    Constants.socket?.off(Constants.receiveConversation);
    Constants.socket?.off(Constants.error);
    super.onClose();
  }
}
