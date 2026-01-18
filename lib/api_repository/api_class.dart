import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'package:buddy/api_repository/loading.dart';
import 'package:buddy/core/constants/constants.dart';
import 'package:buddy/core/constants/helper.dart';

/// HTTP utility class for API requests
class HttpUtil {
  // Body params name
  static String name = "name";
  static String firstName = "firstname";
  static String lastName = "lastname";
  static String email = "email";
  static String password = "password";
  static String authProvider = "auth_provider";
  static String gender = "gender";
  static String age = "age";
  static String personalityType = "personality_type";
  static String profileImageUrl = "profile_image_url";
  static String otp = "otp";
  static String pin = "pin";
  static String newPin = "newPin";
  static String oldPin = "oldPin";
  static String deviceId = "device_id";
  static String isForgetPin = "isForgetPin";
  static String conversationId = "conversation_id";
  static String isArchive = "isArchive";
  static String message = "message";
  static String objective = "objective";
  static String selectedGift = "selected_gift";
  static String selectedRelation = "selected_relation";
  static String selectedRelationType = "selected_relation_type";
  static String selectedRelationVibe = "selected_relation_vibe";
  static String selectedRelationRange = "selected_relation_range";
  static String imageAnalyzer = "image_analyzer";
  static String dateIdeaGen = "date_idea";

  static String content = "content";
  static String userId = "user_id";
  static String id = "id";
  static String fileData = "file_data";
  static String skip = "skip";
  static String size = "size";
  static String filePath = "filePath";
  static String messageId = "message_id";
  static String isManually = "is_manually";
  static String isSparkDLine = "is_sparkd_line";
  static const String previousSuggestions = "previous_suggestions";
  static const String giftFor = "gift_for";
  static const String partnershipStage = "partnership_stage";
  static const String recipientInterest = "recipient_interest";
  static const String giverVibe = "giver_vibe";
  static const String budget = "budget";
  static const String nameForGift = "name";
  static const String genderOfGift = "gender";
  static const String ageOfGift = "age";
  static const String personality = "personality";

  factory HttpUtil(String token, bool isLoading, BuildContext context) =>
      _instance(token, isLoading, context);

  static HttpUtil _instance(token, isLoading, context) =>
      HttpUtil._internal(token: token, isLoading: isLoading, context: context);

  late Dio dio;
  CancelToken cancelToken = CancelToken();
  String apiUrl = Constants.baseUrl;

  BuildContext? context;

  HttpUtil._internal(
      {String? token, bool? isLoading, required BuildContext context}) {
    if (utils.isValidationEmpty(token)) {
      token = getStorageData.readString(getStorageData.tokenKey);
    }
    BaseOptions options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: Duration(minutes: 1),
      receiveTimeout: Duration(minutes: 1),
      headers: {
        'Authorization': "Bearer $token",
      },
      // contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );

    dio = Dio(options);
    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (isLoading!) {
          Loading.show();
        }
        return handler.next(options); //continue
      },
      onResponse: (response, handler) {
        if (isLoading!) {
          Loading.dismiss();
        }

        return handler.next(response); // continue
      },
      onError: (DioError e, handler) async {
        Loading.dismiss();

        return handler.resolve(e.response!);
      },
    ));
  }

// On Error....
  void onError(ErrorEntity eInfo, BuildContext context) {
    printError(
        "error.code -> ${eInfo.code}, error.message -> ${eInfo.message}");
    if (eInfo.message.isNotEmpty) {
      utils.showToast(message: eInfo.message);
    }
  }

  createErrorEntity(DioError error) {
    Loading.dismiss();
    // if (utils.isValidationEmpty(error.message)) {
    //   errorEntity(code: 0, message: "Your internet is not available, please try again later");
    // }

    switch (error.type) {
      // case DioErrorType.cancel:
      //   errorEntity(code: -1, message: "Request to server was cancelled");
      //   break;
      // case DioErrorType.connectionTimeout:
      //   errorEntity(code: -2, message: "Connection timeout with server");
      //   break;
      // case DioErrorType.sendTimeout:
      //   errorEntity(code: -3, message: "Send timeout in connection with server");
      //   break;
      // case DioErrorType.receiveTimeout:
      //   errorEntity(code: -4, message: "Receive timeout in connection with server");
      //   break;
      case DioErrorType.badResponse:
        {
          try {
            int errCode =
                error.response != null ? error.response!.statusCode! : 00;
            switch (errCode) {
              // case 400:
              // errorEntity(code: errCode, message: "Request syntax error");
              // break;
              case 401:
                errorEntity(code: errCode, message: "Permission denied");
                break;
              // case 403:
              //   errorEntity(code: errCode, message: "Server refuses to execute");
              //   break;
              // case 404:
              //   errorEntity(code: errCode, message: "Can not reach server");
              //   break;
              // case 405:
              //   errorEntity(code: errCode, message: "Request method is forbidden");
              //   break;
              // case 500:
              //   errorEntity(code: errCode, message: "Internal server error");
              //   break;
              // case 502:
              //   errorEntity(code: errCode, message: "Invalid request");
              //   break;
              // case 503:
              //   errorEntity(code: errCode, message: "Server hangs");
              //   break;
              // case 505:
              //   errorEntity(code: errCode, message: "HTTP protocol requests are not supported");
              //   break;
              default:
                utils.showToast(message: error.response!.data['message']);
              // errorEntity(code: errCode, message: error.response != null ? error.response!.data! : "");
            }
          } on Exception catch (_) {
            errorEntity(code: 0, message: "Unknown mistake");
          }
        }
        break;
      case DioErrorType.unknown:
        if (error.message!.contains("SocketException")) {
          errorEntity(
              code: -5,
              message:
                  "Your internet is not available, please try again later");
        } else if (error.message!
            .contains("Software caused connection abort")) {
          errorEntity(
              code: -6,
              message:
                  "Your internet is not available, please try again later");
        }
        errorEntity(code: -7, message: "Oops something went wrong");
        break;
      default:
        errorEntity(code: -8, message: "Oops something went wrong");
        break;
    }
  }

  void cancelRequests() {
    cancelToken.cancel("cancelled");
  }

  /// restful get
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool noCache = true,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ??
        Options(
          receiveTimeout: Duration(minutes: 10),
          // headers: Constants.headers,
          // contentType: 'application/json; charset=utf-8',
          responseType: ResponseType.json,
        );
    ;
    requestOptions.extra ??= {};
    requestOptions.extra!.addAll({
      "refresh": refresh,
      "noCache": noCache,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });

    var response = await dio.get(
      path,
      // queryParameters: queryParameters,
      // options: options,
      // cancelToken: cancelToken,
    );
    return response;
  }

  /// restful post
  Future post(
    String path, {
    FormData? data,
    Object? withOutFormData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ??
        Options(
          receiveTimeout: Duration(minutes: 10),
          // headers: Constants.headers,
          // contentType: 'application/json; charset=utf-8',
          responseType: ResponseType.json,
        );
    // String dummy = jsonEncode();

    // print("withOutFormData-->$withOutFormData");
    var response = await dio.post(
      path,
      data: data ?? withOutFormData,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful put
  Future put(
    String path, {
    FormData? data,
    Object? withOutFormData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();

    var response = await dio.put(
      path,
      data: data ?? withOutFormData,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful delete
  Future delete(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();

    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful patch
  Future patch(
    String path, {
    FormData? data,
    Object? withOutFormData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();

    var response = await dio.patch(
      path,
      data: data ?? withOutFormData,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful post form
  Future postForm(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();

    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful post Stream
  Future postStream(
    String path, {
    dynamic data,
    int dataLength = 0,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();

    requestOptions.headers!.addAll({
      Headers.contentLengthHeader: dataLength.toString(),
    });
    var response = await dio.post(
      path,
      data: Stream.fromIterable(data.map((e) => [e])),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }
}

void errorEntity({
  required code,
  required message,
}) {
  if (!utils.isValidationEmpty(message)) {
    printAction("test_message: $message");
    utils.showToast(message: message);
  }
}

class ErrorEntity implements Exception {
  int code = -1;
  String message = "";

  ErrorEntity({
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    printAction("test_message: $message");

    if (!utils.isValidationEmpty(message)) {
      printAction("test_message: $message");
      utils.showToast(message: message);
    }

    if (message == "") {
      return "Exception";
    } else {
      return "Exception: code $code, $message";
    }
  }
}

