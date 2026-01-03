import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:buddy/api_repository/api_class.dart';
import 'package:buddy/api_repository/api_function.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/models/file_upload_response.dart';
import 'package:buddy/pages/home/image_chat/model/image_model.dart';

class ImageChatController extends GetxController {
  static const String socketBaseUrl = "http://3.123.108.18:3000/";
  static const String uploadFileEndpoint =
      "http://3.123.108.18:3000/api/chat/upload-file";

  late io.Socket socket;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var messages = <Datum>[].obs;
  var isLoading = false.obs;
  String? imagePath;
  ImageAnalyzerModel? imageAnalyzerModel;
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
      imageAnalyzerModel = Get.arguments[HttpUtil.imageAnalyzer];
      userId = getStorageData.readString(getStorageData.userIdKey);
      print("this is userid$userId");
      conversationId = Get.arguments[HttpUtil.conversationId];

      if (imageAnalyzerModel != null && imageAnalyzerModel!.data.isNotEmpty) {
        messages.addAll(imageAnalyzerModel!.data);
      }
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

    socket.on('receiveMessage', (data) {
      print("i am in image chat");
      try {
        if (data is Map) {
          handleSingleMessage(data);
        } else if (data is List) {
          handleMultipleMessages(data);
        }
      } catch (e) {
        print("Error parsing message: $e");
      }
      isLoading.value = false;
      scrollToBottom();
    });
    socket.on('receiveRegenerate', (data) {
      print("regen data $data");

      try {
        if (data is Map) {
          handleSingleMessage(data);
        } else if (data is List) {
          handleMultipleMessages(data);
        }
      } catch (e) {
        print("Error parsing message: $e");
      }
      isLoading.value = false;
      scrollToBottom();
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

  void handleSingleMessage(Map data) {
    final parsedMap = data.map((key, value) => MapEntry(key.toString(), value));
    final newMessage = Datum.fromJson(parsedMap);
    updateMessages(newMessage);
  }

  void handleMultipleMessages(List data) {
    for (var item in data) {
      if (item is Map) {
        final parsedMap =
            item.map((key, value) => MapEntry(key.toString(), value));
        final newMessage = Datum.fromJson(parsedMap);
        updateMessages(newMessage);
      }
    }
  }

  void updateMessages(Datum newMessage) {
    if (isRegenerating && messages.isNotEmpty) {
      messages[messages.length - 1] = newMessage;
      isRegenerating = false;
    } else {
      // Check if this message already exists (to prevent duplicates)
      // This happens when we add message optimistically and then receive it from socket
      bool messageExists = false;
      
      // If message has an ID, check by ID
      if (newMessage.id != null && newMessage.id!.isNotEmpty) {
        messageExists = messages.any((msg) => msg.id == newMessage.id);
      }
      
      // If no ID or not found by ID, check if it's from current user and matches last message
      if (!messageExists && newMessage.senderId == userId) {
        if (messages.isNotEmpty) {
          final lastMessage = messages.last;
          // Check if last message is from same sender, has same content, and no ID (optimistic message)
          if (lastMessage.senderId == userId &&
              lastMessage.content == newMessage.content &&
              (lastMessage.id == null || lastMessage.id!.isEmpty)) {
            // Replace the optimistic message with the server version
            messages[messages.length - 1] = newMessage;
            messageExists = true;
          }
        }
      }
      
      // Only add if message doesn't exist
      if (!messageExists) {
        messages.add(newMessage);
      }
    }
  }

  void sendMessage() {
    final content = textController.text.trim();
    if (content.isEmpty) return;

    final messageData = {
      "user_id": userId,
      "conversation_id": conversationId,
      "content": content,
      "file_data": "",
    };

    final newMessage = Datum(
      senderId: userId!,
      content: content,
      fileUrl: null,
    );

    messages.add(newMessage);
    isLoading.value = true;
    socket.emit('sendMessage', messageData);
    textController.clear();
    scrollToBottom();
  }

  void sendRegenrateMessage() {
    isRegenerating = true;
    isLoading.value = true;
    final messageData = {
      "user_id": userId,
      "conversation_id": conversationId,
    };

    print(messageData);
    socket.emit('regenerate', messageData);
  }

  Future<void> sendImage(String localImagePath) async {
    try {
      final messageData = {
        "user_id": userId,
        "conversation_id": conversationId,
        "content": "",
        "file_data": localImagePath,
        "regenerate": "false",
      };

      final newMessage = Datum(
        senderId: userId,
        content: "",
        fileUrl: imagePath,
      );

      messages.add(newMessage);
      isLoading.value = true;
      socket.emit('sendMessage', messageData);
      scrollToBottom();
    } catch (e) {
      Get.snackbar('Upload Error', 'Failed to upload image: $e');
      isLoading.value = false;
    }
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

  Future<void> uploadImage() async {
    try {
      if (imagePath == null) return;

      FormData formData = FormData.fromMap({
        HttpUtil.profileImageUrl: await MultipartFile.fromFile(
          imagePath!,
          filename: imagePath!.split("/").last,
        ),
      });

      final data = await APIFunction().patchApiCall(
        apiName: Constants.uploadFile,
        data: formData,
      );

      // Check if response is an error (has statusCode field)
      if (data is Map<String, dynamic> && data.containsKey('statusCode')) {
        // This is an error response
        final errorMessage = data['message'] ?? 'Upload failed';
        isLoading.value = false;
        utils.showToast(message: errorMessage);
        return;
      }

      // Try to parse as successful response
      FileUploadResponse model = FileUploadResponse.fromJson(data);
      if (model.success!) {
        await sendImage(model.data ?? "");
      } else {
        utils.showToast(message: model.message ?? 'Upload failed');
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      // Try to extract error message from exception
      String errorMessage = "Image upload failed";
      if (e is DioException && e.response != null) {
        try {
          final errorData = e.response!.data;
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'] ?? errorMessage;
          }
        } catch (_) {}
      }
      utils.showToast(message: errorMessage);
    }
  }

  @override
  void onClose() {
    socket.disconnect();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
