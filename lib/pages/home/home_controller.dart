import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:buddy_ai_wingman/api_repository/api_class.dart';
import 'package:buddy_ai_wingman/core/constants/helper.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/home/image_chat/model/image_model.dart';
import 'package:buddy_ai_wingman/pages/home/model/message_model.dart';
import 'package:buddy_ai_wingman/pages/new_chat/chat/error_response.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

import '../../../api_repository/api_function.dart';

class HomeController extends GetxController {
  String? imagePath;
  String? userId;

  static const String socketBaseUrl = "http://3.92.114.189:3004/";
  static const String uploadFileEndpoint =
      "http://3.92.114.189:3005/api/chat/upload-file";
  var isLoading = false.obs;
  late io.Socket socket;
  List<MessageModelPickup>? messages;
  ImageAnalyzerModel? model;
  @override
  void onInit() {
    super.onInit();

    userId = getStorageData.readString(getStorageData.userIdKey);

    initSocket();
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
      try {
        isLoading.value = false; // Hide loader when data is received

        if (data is List<dynamic>) {
          // Ensure data is properly cast before mapping
          messages = data
              .map((msg) =>
                  MessageModelPickup.fromMap(msg as Map<String, dynamic>))
              .toList();

          print("Received messages: $messages");

          // Navigate and pass parsed list
          if (messages!.isNotEmpty) {
            Get.offNamed(Routes.PICKUP_LINES, arguments: {
              HttpUtil.message: messages, // Pass full list
              HttpUtil.conversationId: messages![0].conversationId
            });
          }
        } else if (data is Map<String, dynamic>) {
          // If it's a single message, parse it
          final message = MessageModelPickup.fromMap(data);
          print("Received single message: ${message.content}");

          Get.toNamed(Routes.PICKUP_LINES, arguments: {
            HttpUtil.message: [message], // Wrap single message in a list
            HttpUtil.conversationId: message.conversationId
          });
        } else {
          print("Unexpected data format: $data");
        }
      } catch (e) {
        print("Error parsing socket data: $e");
        isLoading.value = false;
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
    final Map<String, dynamic> messageData = {
      "user_id": userId,
    };

    isLoading.value = true; // Show loader

    socket.emit('getOpeningLines', messageData);
  }

  uploadImage() async {
    FormData formData = FormData();
    printAction("imagePath >>>>>>>>>>> $imagePath");
    if (imagePath != null) {
      formData.fields.add(const MapEntry("name", "static"));
      formData.files.add(MapEntry(
          HttpUtil.profileImageUrl,
          MultipartFile.fromFileSync(
            imagePath!,
            filename: imagePath!.split("/").last,
          )));
    }
    final data = await APIFunction().patchApiCall(
      apiName: "chat/with-file",
      data: formData,
    );

    print("this is api response $data ");
    try {
      model = ImageAnalyzerModel.fromJson(data);
      if (model!.success) {
        update();

        Get.toNamed(Routes.IMAGE_CHAT, arguments: {
          HttpUtil.imageAnalyzer: model,
          HttpUtil.conversationId: model!.data[0].conversationId
        });
      } else {
        utils.showToast(message: model!.message!);
      }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      utils.showToast(message: errorModel.message!);
    }
  }

  void addNewChatManually(bool value) {
    Map chatmsg = {"name": "add new chat manual Chat"};
    Constants.socket!.emit("logEvent", chatmsg);
    Get.toNamed(
      Routes.GATHER_NEW_CHAT_INFO,
      arguments: {
        if (!value) HttpUtil.filePath: imagePath,
        HttpUtil.isManually: value,
      },
    );
  }

  @override
  void onClose() {
    socket.disconnect();
    socket.dispose();
    print('Socket disconnected in onClose');
    super.onClose();
  }
}

List<SparkLinesModel> linesList = [
  SparkLinesModel(text: "👋 Casual Hi"),
  SparkLinesModel(text: "😘 Flirty Compliment"),
  SparkLinesModel(text: "🌇 Ask About"),
  SparkLinesModel(text: "🗓️ Weekend Plans"),
  SparkLinesModel(text: "🎬 Favorite Movie"),
  SparkLinesModel(text: "🎶 Go-To Song"),
  SparkLinesModel(text: "✈️ Best Travel"),
  SparkLinesModel(text: "👗 Compliment Style"),
  SparkLinesModel(text: "💼 Dream Job"),
  SparkLinesModel(text: "🦁 Spirit Animal"),
  SparkLinesModel(text: "💖 Compliment Kindness"),
  SparkLinesModel(text: "🌟 Childhood Dream"),
  SparkLinesModel(text: "🌞 Good Morning"),
  SparkLinesModel(text: "🏝️ Ideal Vacation"),
  SparkLinesModel(text: "😆 Compliment Humor"),
  SparkLinesModel(text: "🌟 Quote Inspire"),
  SparkLinesModel(text: "🍕 Favorite Food"),
  SparkLinesModel(text: "♌ Zodiac Sign"),
  SparkLinesModel(text: "🍝 Dinner Idea"),
  SparkLinesModel(text: "🤓 Fun Fact"),
  SparkLinesModel(text: "📚 Favorite Book"),
  SparkLinesModel(text: "❓ Random Question"),
  SparkLinesModel(text: "🎨 Hobbies Interests"),
  SparkLinesModel(text: "📺 Favorite TV"),
  SparkLinesModel(text: "🎯 Goals"),
  SparkLinesModel(text: "😊 Compliment Smile"),
  SparkLinesModel(text: "🌴 Relax Place"),
  SparkLinesModel(text: "🎭 Hidden Talent"),
  SparkLinesModel(text: "🧀 Pickup Line"),
  SparkLinesModel(text: "🐶 Ask Pets"),
  SparkLinesModel(text: "💭 Daydreams"),
  SparkLinesModel(text: "🍫 Guilty Pleasure"),
  SparkLinesModel(text: "⚽ Sport Activity"),
  SparkLinesModel(text: "👀 Compliment Eyes"),
  SparkLinesModel(text: "🍂 Favorite Season"),
  SparkLinesModel(text: "🎉 Fun Challenge"),
  SparkLinesModel(text: "🧠 Fact of Day"),
  SparkLinesModel(text: "🎄 Favorite Holiday"),
  SparkLinesModel(text: "😂 Funny Meme"),
  SparkLinesModel(text: "📝 Bucket List"),
  SparkLinesModel(text: "💪 Morning Motivation"),
  SparkLinesModel(text: "🐾 Cute Photo"),
  SparkLinesModel(text: "☕ Coffee Tea"),
  SparkLinesModel(text: "🏖️ Weekend Vibes"),
  SparkLinesModel(text: "🤳 Silly Selfie"),
];

class SparkLinesModel {
  final String text;

  SparkLinesModel({
    required this.text,
  });
}
