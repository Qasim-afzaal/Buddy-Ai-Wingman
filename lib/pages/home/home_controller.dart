import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:buddy/api_repository/api_class.dart';
import 'package:buddy/core/constants/constants.dart';
import 'package:buddy/core/constants/helper.dart';
import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/core/services/notification_service.dart';
import 'package:buddy/pages/home/image_chat/model/image_model.dart';
import 'package:buddy/pages/home/model/message_model.dart';
import 'package:buddy/pages/new_chat/chat/error_response.dart';
import 'package:buddy/routes/app_pages.dart';

import '../../../api_repository/api_function.dart';

class HomeController extends GetxController {
  String? imagePath;
  String? userId;

  // Use centralized constants from Constants class
  String get socketBaseUrl => Constants.socketBaseUrl;
  String get uploadFileEndpoint => "${Constants.baseUrl}${Constants.uploadFile}";
  var isLoading = false.obs;
  late io.Socket socket;
  List<MessageModelPickup>? messages;
  ImageAnalyzerModel? model;
  @override
  void onInit() {
    super.onInit();

    userId = getStorageData.readString(getStorageData.userIdKey);

    initSocket();
    
    // Print user info after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      printUserInfo();
    });
    
    // Update device token (OneSignal Player ID) to backend
    Future.delayed(const Duration(milliseconds: 2000), () {
      updateDeviceToken();
    });
  }

  /// Update device token (OneSignal Player ID) to backend
  Future<void> updateDeviceToken() async {
    try {
      debugPrint("🔄 Updating device token to backend...");
      
      // Get OneSignal Player ID
      String? playerId = await NotificationService.instance.getPlayerId();
      
      if (playerId == null || playerId.isEmpty) {
        debugPrint("⚠️ Player ID not available yet, retrying...");
        // Retry after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          updateDeviceToken();
        });
        return;
      }
      
      // Determine platform
      String platform = Platform.isIOS ? "ios" : (Platform.isAndroid ? "android" : "unknown");
      
      // Prepare request data
      final requestData = {
        "onesignal_player_id": playerId,
        "platform": platform,
      };
      
      debugPrint("📤 Sending device token update:");
      debugPrint("   Player ID: $playerId");
      debugPrint("   Platform: $platform");
      
      // Make API call
      final token = getStorageData.readString(getStorageData.tokenKey);
      final response = await APIFunction().apiCall(
        apiName: "user-devices",
        withOutFormData: jsonEncode(requestData),
        token: token ?? "",
        isLoading: false, // Don't show loading indicator
      );
      
      debugPrint("✅ Device token updated successfully");
      debugPrint("   Response: $response");
      
    } catch (e) {
      debugPrint("❌ Error updating device token: $e");
      // Don't show error to user, just log it
    }
  }

  /// Print user information to logs
  void printUserInfo() {
    final userName = getStorageData.readString(getStorageData.userName) ?? 'N/A';
    final userEmail = getStorageData.readString(getStorageData.userEmailId) ?? 'N/A';
    final platform = Platform.isIOS ? 'iOS' : (Platform.isAndroid ? 'Android' : 'Unknown');
    
    // Get subscription info
    String subscription = 'N/A';
    try {
      final storedProductId = getStorageData.readString("subscribed_product_id");
      if (storedProductId != null) {
        if (storedProductId.contains("basic")) {
          subscription = "Basic";
        } else if (storedProductId.contains("pro")) {
          subscription = "Pro";
        } else {
          subscription = "Active";
        }
      } else {
        // Check if user is on trial
        final loginData = getStorageData.readLoginData();
        final createdAtString = loginData.data?.createdAt;
        if (createdAtString != null && createdAtString.isNotEmpty) {
          final createdAt = DateTime.tryParse(createdAtString);
          if (createdAt != null) {
            final now = DateTime.now();
            final trialEndDate = createdAt.add(const Duration(days: 7));
            if (now.isBefore(trialEndDate)) {
              subscription = "Free Trial";
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error getting subscription info: $e");
    }
    
    debugPrint('========================================');
    debugPrint('USER INFORMATION (HOME SCREEN)');
    debugPrint('========================================');
    debugPrint('Name: $userName');
    debugPrint('Email: $userEmail');
    debugPrint('Platform: $platform');
    debugPrint('Subscription: $subscription');
    debugPrint('========================================');
  }

  void initSocket() {
    socket = io.io(
      this.socketBaseUrl,
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
            Get.toNamed(Routes.PICKUP_LINES, arguments: {
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
    // Validate image path before proceeding
    if (imagePath == null || imagePath!.isEmpty) {
      utils.showToast(message: 'Please select an image first');
      return;
    }

    // Check if file exists
    final file = File(imagePath!);
    if (!await file.exists()) {
      utils.showToast(message: 'Selected image file not found');
      return;
    }

    try {
      FormData formData = FormData();
      printAction("imagePath >>>>>>>>>>> $imagePath");
      formData.fields.add(const MapEntry("name", "static"));
      formData.files.add(MapEntry(
          HttpUtil.profileImageUrl,
          MultipartFile.fromFileSync(
            imagePath!,
            filename: imagePath!.split("/").last,
          )));

      final data = await APIFunction().patchApiCall(
        apiName: "chat/with-file",
        data: formData,
      );

      print("this is api response $data ");
      
      // Check if response is an error (has statusCode field)
      if (data is Map<String, dynamic> && data.containsKey('statusCode')) {
        // This is an error response
        final errorMessage = data['message'] ?? 'Upload failed. Please try again.';
        debugPrint('❌ Image upload error: $errorMessage');
        utils.showToast(message: errorMessage);
        return;
      }

      model = ImageAnalyzerModel.fromJson(data);
      if (model!.success && model!.data.isNotEmpty) {
        update();

        Get.toNamed(Routes.IMAGE_CHAT, arguments: {
          HttpUtil.imageAnalyzer: model,
          HttpUtil.conversationId: model!.data[0].conversationId
        });
      } else {
        final errorMsg = model?.message ?? 'Upload failed. Please try again.';
        debugPrint('❌ Image upload failed: $errorMsg');
        utils.showToast(message: errorMsg);
      }
    } on FileSystemException catch (e) {
      debugPrint('❌ File system error during upload: $e');
      utils.showToast(message: 'Error reading image file. Please try again.');
    } catch (e) {
      debugPrint('❌ Unexpected error during image upload: $e');
      // Try to extract error message from response
      String errorMessage = "Upload failed. Please check your connection and try again.";
      try {
        if (e is DioException) {
          errorMessage = e.response?.data?['message'] ?? 
                        e.message ?? 
                        'Network error. Please try again.';
        }
      } catch (_) {
        // Fallback to default message
      }
      utils.showToast(message: errorMessage);
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
