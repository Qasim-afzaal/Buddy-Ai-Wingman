import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:buddy_ai_wingman/core/constants/get_storage.dart';
import 'package:buddy_ai_wingman/core/constants/helper.dart';

GetStorageData getStorageData = GetStorageData();
Utils utils = Utils();

class Constants {
  /// Socket
  static IO.Socket? socket;
  static const String socketBaseUrl = "http://18.190.30.218:3004/";

  /// Socket emit event
  static const String sendMessage = 'sendMessage';
  static const String getConversationDetail = 'getConversationDetail';
  static const String getSuggestionAgain = 'getSuggestionAgain';
  static const String manualChat = 'manualChat';

  /// Socket Listening event
  static const String receiveMessage = 'receiveMessage';
  static const String receiveConversation = 'receiveConversation';
  static const String suggestion = 'suggestion';
  static const String message = 'message';
  static const String error = 'Error';

  /// API
  static const String baseUrl = 'http://3.92.114.189:3005/api/';

  /// Users API end point
  static const String signUp = 'users/register';

  /// Auth API end point
  static const String login = 'auth/login';
  static const String loginByPin = 'auth/login-by-pin';
  static const String sendOTP = 'auth/send-otp';
  static const String sendOTPforEmail = 'auth/send-email-verification';
  static const String verifyOTP = 'auth/verify-otp';
  static const String createPin = 'auth/create-pin';
  static const String updatePin = 'auth/update-pin';
  static const String forgetPassword = 'auth/forget-password';

  /// Chat API end point
  static const String withFile = 'chat/with-file';
  static const String uploadFile = 'chat/upload-file';
  static const String sparkdLines = 'chat/sparkd-lines';
  static const String archiveChat = 'chat/archive-chat';
  static const String chatList = 'chat/chat-list/';
  static const String deleteSingle = 'chat/single/';
  static const String clearAll = 'chat/clear-all';
  static const String deleteUser = 'users/';
}
