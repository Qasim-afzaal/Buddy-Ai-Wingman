import 'dart:convert';

import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/api_repository/api_function.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/inbox/archive_response.dart';
import 'package:buddy_ai_wingman/pages/inbox/delete_response.dart';
import 'package:buddy_ai_wingman/pages/inbox/index_response.dart';
import 'package:buddy_ai_wingman/widgets/CustomDropDown.dart';

import '../../models/error_response.dart';

class InboxController extends GetxController {
  Rx<InboxType> selectedType = InboxType.Chats.obs;
  RxList<IndexResponseData> inboxList = <IndexResponseData>[].obs;
  RxList<IndexResponseData> allInboxList = <IndexResponseData>[].obs;
  RxList<DropDownItem> dropDownList = <DropDownItem>[].obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    callChatList(selectedType.value, true);
    super.onInit();
  }

  void callChatList(InboxType inboxType, bool isLoading) async {
    Map msg = {"name": ".Inbox Api Calling"};
    Constants.socket!.emit("logEvent", msg);
    selectedType.value = inboxType;
    searchController.text = "";
    inboxList.clear();
    allInboxList.clear();

    final data = await APIFunction().apiCall(
      apiName:
          Constants.chatList + (inboxType == InboxType.Archived).toString(),
      isGet: true,
      isLoading: isLoading,
    );
    print("this is chat data $data");
    Map chatmsg = {"name": ".Inbox Api Api CALLED"};
    Constants.socket!.emit("logEvent", chatmsg);
    try {
      IndexResponse mainModel = IndexResponse.fromJson(data);

      if (mainModel.success!) {
        if (mainModel.data!.isEmpty) {
          if (isLoading) {
            utils.showToast(message: mainModel.message!);
          }
        } else {
          inboxList.clear();
          allInboxList.clear();
          inboxList.addAll(mainModel.data!);
          allInboxList.addAll(mainModel.data!);
          dropDownList = [
            DropDownItem(
                iconPath: Assets.icons.archived.path,
                text:
                    (selectedType == InboxType.Chats) ? "Archive" : "Unarchive",
                value: "Archive"),
            DropDownItem(
                iconPath: Assets.icons.delete.path,
                text: "Delete",
                value: "Delete"),
          ].obs;
        }
      } else {
        if (isLoading) {
          utils.showToast(message: mainModel.message!);
        }
      }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    }
    update();
  }

  void deleteChat(String conversationId, int index) async {
    final data = await APIFunction()
        .deleteApiCall(apiName: Constants.deleteSingle + conversationId);
    Map chatmsg = {"name": "Delete Api calling"};
    Constants.socket!.emit("logEvent", chatmsg);
    try {
      DeleteResponse mainModel = DeleteResponse.fromJson(data);
      if (mainModel.success!) {
        inboxList.removeAt(index);
        allInboxList.removeAt(index);
        update();
        utils.showToast(message: mainModel.message!);
      } else {
        utils.showToast(message: mainModel.message!);
      }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    }
  }

  void archiveChat(String conversationId, int index) async {
    var json = {
      HttpUtil.conversationId: conversationId,
      HttpUtil.isArchive: (selectedType == InboxType.Chats),
    };
    final data = await APIFunction().patchApiCall(
      apiName: Constants.archiveChat,
      withOutFormData: jsonEncode(json),
    );
    Map chatmsg = {"name": "${HttpUtil.email} ARCHIVE Api calling"};
    Constants.socket!.emit("logEvent", chatmsg);
    try {
      ArchiveResponse mainModel = ArchiveResponse.fromJson(data);
      Map chatmsg = {"name": "${HttpUtil.email} Api called"};
      Constants.socket!.emit("logEvent", chatmsg);
      if (mainModel.success!) {
        inboxList.removeAt(index);
        allInboxList.removeAt(index);
        update();
      } else {
        utils.showToast(message: mainModel.message!);
      }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    }
  }
}
