import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:buddy/api_repository/api_class.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/home/model/message_model.dart';
import 'package:buddy/core/config/app_config.dart';

class PickupLineController extends GetxController {
  static String get socketBaseUrl => AppConfig.socketBaseUrl;
  static String get uploadFileEndpoint => '${AppConfig.apiBaseUrl}chat/upload-file';

  late io.Socket socket;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var messages = <MessageModelPickup>[].obs; // Make messages an observable list

  var isLoading = false.obs;
  String? imagePath;

  String? conversationId;
  String? userId;
  bool isRegenerating = false;

  @override
  void onInit() {
    super.onInit();
    initializeChat();
    initSocket();
  }

  void initializeChat() {
    if (Get.arguments != null) {
      var receivedMessages = Get.arguments[HttpUtil.message];

      userId = getStorageData.readString(getStorageData.userIdKey);
      conversationId = Get.arguments[HttpUtil.conversationId];

      if (receivedMessages is List) {
        if (receivedMessages.isNotEmpty &&
            receivedMessages.first is Map<String, dynamic>) {
          messages.value = receivedMessages
              .map((msg) => MessageModelPickup.fromMap(msg))
              .toList();
        } else {
          messages.value = List<MessageModelPickup>.from(receivedMessages);
        }
      } else {
        messages.clear();
      }

      print("Messages initialized: ${messages.length}");
    }
  }

  void initSocket() {
    socket = io.io(
      socketBaseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    socket.connect();

    socket.onConnect((_) {
      print('Socket connected');
    });

    socket.on('receiveOpeningLines', (data) {
      isLoading.value = false; // Hide loader when data is received
      print("this is data: $data");

      if (data is List && data.isNotEmpty) {
        var newMessage = MessageModelPickup.fromMap(
            data.first); // Get the first message from the received data

        if (messages.isNotEmpty) {
          // Update the first index instead of replacing the whole list
          messages[0] = newMessage;
        } else {
          // If the list is empty, add the first message
          messages.add(newMessage);
        }
      } else {
        print("Unexpected data format received: $data");
      }
    });

    socket.onError((error) {
      Get.snackbar('Error', 'Socket error: $error');
      isLoading.value = false;
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
      isLoading.value = false;
    });
  }

  void startChat() {
    // Construct messageData based on condition
    final Map<String, dynamic> messageData = {
      "user_id": userId,
      "conversation_id": conversationId,
    };

    isLoading.value = true;

    socket.emit('getOpeningLines', messageData);
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    socket.disconnect();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
