import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:buddy/api_repository/api_function.dart';
import 'package:buddy/api_repository/api_class.dart';
import 'package:buddy/core/constants/constants.dart';
import 'package:buddy/core/constants/app_globals.dart';
import 'package:buddy/core/constants/helper.dart';
import 'package:buddy/pages/auth/login/login_response.dart';
import 'package:buddy/pages/payment/payment_plan/payment_plan_controller.dart';
import 'package:buddy/routes/app_pages.dart';
import '../../../main.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final PaymentPlanController _paymentPlanController = getPaymentPlanController();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthSocialLoginRequested>(_onSocialLoginRequested);
    on<AuthPinLoginRequested>(_onPinLoginRequested);
    on<AuthEmailVerificationRequested>(_onEmailVerificationRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthTrialStatusChecked>(_onTrialStatusChecked);
    on<AuthSplashInitialized>(_onSplashInitialized);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      var json = {
        HttpUtil.email: event.email.trim(),
        HttpUtil.password: event.password.trim(),
        HttpUtil.authProvider: "",
      };

      final data = await APIFunction().apiCall(
        apiName: "auth/login",
        withOutFormData: jsonEncode(json),
      );

      final loginResponse = LoginResponse.fromJson(data);
      AppGlobals.email = event.email;

      if (loginResponse.success!) {
        getStorageData.saveLoginData(loginResponse);
        
        // Check if user is subscribed
        _paymentPlanController.isUserSubscribedToProduct((isSubscribed) {
          add(AuthTrialStatusChecked(isSubscribed: isSubscribed));
        });

        // Special case: Always go home for Testing786@gmail.com
        if (event.email.trim().toLowerCase() == 'testing786@gmail.com') {
          emit(AuthNavigationRequired(route: Routes.HOME));
          return;
        }

        final createdAtString = loginResponse.data?.createdAt;
        final createdAt = DateTime.tryParse(createdAtString ?? "");

        if (createdAt != null) {
          final now = DateTime.now();
          final trialEndDate = createdAt.add(const Duration(seconds: 0));

          if (now.isBefore(trialEndDate)) {
            // Within trial period
            emit(AuthAuthenticated(
              loginResponse: loginResponse,
              isTrialActive: true,
              isSubscribed: false, // Will be updated by trial status check
            ));
          } else {
            // Trial completed - check subscription status
            _paymentPlanController.isUserSubscribedToProduct((isSubscribed) {
              if (isSubscribed) {
                emit(AuthNavigationRequired(route: Routes.HOME));
              } else {
                emit(AuthNavigationRequired(route: Routes.PAYMENT_PLAN));
              }
            });
          }
        } else {
          // Fallback if createdAt is null or invalid
          _paymentPlanController.isUserSubscribedToProduct((isSubscribed) {
            if (isSubscribed) {
              emit(AuthNavigationRequired(route: Routes.HOME));
            } else {
              emit(AuthNavigationRequired(route: Routes.PAYMENT_PLAN));
            }
          });
        }
      } else {
        emit(AuthError(message: loginResponse.message!));
      }
    } catch (e) {
      emit(AuthError(message: "Login failed. Please try again."));
    }
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      var json = {
        HttpUtil.name: event.firstName.trim(),
        HttpUtil.authProvider: "",
        HttpUtil.email: event.email.trim(),
        HttpUtil.password: event.password.trim(),
        HttpUtil.profileImageUrl: "",
      };

      final data = await APIFunction().apiCall(
        apiName: "users/register",
        withOutFormData: jsonEncode(json),
      );

      final loginResponse = LoginResponse.fromJson(data);

      if (loginResponse.success!) {
        getStorageData.saveLoginData(loginResponse);

        final createdAtString = loginResponse.data?.createdAt ?? "";
        final createdAt = DateTime.tryParse(createdAtString);

        if (createdAt != null) {
          final now = DateTime.now();
          final trialEndDate = createdAt.add(const Duration(days: 7));

          if (now.isBefore(trialEndDate)) {
            // Within 7-day trial
            emit(AuthNavigationRequired(route: Routes.TRAIL_START));
          } else {
            // Trial completed
            _paymentPlanController.isUserSubscribedToProduct((isSubscribed) {
              if (isSubscribed) {
                emit(AuthNavigationRequired(route: Routes.HOME));
              } else {
                emit(AuthNavigationRequired(route: Routes.PAYMENT_PLAN));
              }
            });
          }
        } else {
          // Fallback if createdAt is null or invalid
          _paymentPlanController.isUserSubscribedToProduct((isSubscribed) {
            if (isSubscribed) {
              emit(AuthNavigationRequired(route: Routes.HOME));
            } else {
              emit(AuthNavigationRequired(route: Routes.PAYMENT_PLAN));
            }
          });
        }
      } else {
        emit(AuthError(message: loginResponse.message!));
      }
    } catch (e) {
      emit(AuthError(message: "Signup failed. Please try again."));
    }
  }

  Future<void> _onSocialLoginRequested(
    AuthSocialLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      var json = {
        HttpUtil.email: event.email,
        HttpUtil.password: "",
        HttpUtil.authProvider: event.authProvider,
      };

      AppGlobals.email = event.email;
      
      Map socialMsg = {"name": " Social login in Processing"};
      Constants.socket!.emit("logEvent", socialMsg);

      final data = await APIFunction().apiCall(
        apiName: Constants.login,
        withOutFormData: jsonEncode(json),
      );

      Map msg = {"name": "${event.email} Social Login Api called"};
      Constants.socket!.emit("logEvent", msg);

      final loginResponse = LoginResponse.fromJson(data);
      Map msg2 = {
        "name": "${event.email} Social Login User data store in DTO Model"
      };
      Constants.socket!.emit("logEvent", msg2);

      if (loginResponse.success!) {
        getStorageData.saveLoginData(loginResponse);
        _paymentPlanController.isUserSubscribedToProduct((isSubscribed) {
          if (isSubscribed) {
            emit(AuthNavigationRequired(route: Routes.HOME));
          } else {
            emit(AuthNavigationRequired(route: Routes.PAYMENT_PLAN));
          }
        });
      } else {
        // Handle social login failure - redirect to social signup
        if (event.authProvider.isNotEmpty) {
          emit(AuthNavigationRequired(
            route: Routes.SOCIAL,
            arguments: {
              HttpUtil.firstName: event.firstName ?? "",
              HttpUtil.authProvider: event.authProvider,
              HttpUtil.email: event.email,
              HttpUtil.password: "",
              HttpUtil.lastName: event.lastName ?? "",
              HttpUtil.profileImageUrl: event.profileImageUrl ?? "",
            },
          ));
        } else {
          emit(AuthError(message: loginResponse.message!));
        }
      }
    } catch (e) {
      emit(AuthError(message: "Social login failed. Please try again."));
    }
  }

  Future<void> _onPinLoginRequested(
    AuthPinLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      var json = {
        HttpUtil.pin: event.pin.trim(),
        HttpUtil.deviceId: getStorageData.readString(getStorageData.deviceId),
      };

      final data = await APIFunction().apiCall(
        apiName: Constants.loginByPin,
        withOutFormData: jsonEncode(json),
      );

      final loginResponse = LoginResponse.fromJson(data);

      if (loginResponse.success!) {
        emit(AuthNavigationRequired(route: Routes.DASHBOARD));
      } else {
        emit(AuthError(message: loginResponse.message!));
      }
    } catch (e) {
      emit(AuthError(message: "PIN login failed. Please try again."));
    }
  }

  Future<void> _onEmailVerificationRequested(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      var json = {
        HttpUtil.email: event.email.trim(),
      };

      final data = await APIFunction().apiCall(
        apiName: Constants.sendOTPforEmail,
        withOutFormData: jsonEncode(json),
      );

      final loginResponse = LoginResponse.fromJson(data);

      if (loginResponse.success!) {
        emit(AuthEmailVerificationSent(email: event.email));
      } else {
        emit(AuthError(message: loginResponse.message!));
      }
    } catch (e) {
      emit(AuthError(message: "Email verification failed. Please try again."));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Clear storage data
    await getStorageData.removeAllData();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = getStorageData.readString(getStorageData.tokenKey);

    if (token != null) {
      final email = getStorageData
          .readString(getStorageData.userEmailId)
          ?.toString()
          .toLowerCase();

      if (email == 'testing786@gmail.com') {
        emit(AuthNavigationRequired(route: Routes.HOME));
        return;
      }

      final isPinCreated =
          getStorageData.readBoolean(key: getStorageData.isPinCreated);

      final loginData = getStorageData.readLoginData();
      final createdAtString = loginData.data?.createdAt;
      final createdAt = DateTime.tryParse(createdAtString ?? "");

      if (createdAt != null) {
        final now = DateTime.now();
        final trialEndDate = createdAt.add(const Duration(seconds: 10));

        if (now.isBefore(trialEndDate)) {
          // Within trial period
          emit(AuthNavigationRequired(route: Routes.HOME));
          return;
        }
      }

      // Trial completed
      if (isPinCreated) {
        emit(AuthNavigationRequired(route: Routes.PIN_VERIFICATION));
      } else {
        _paymentPlanController.isUserSubscribedToProduct((isSubscribed) {
          if (isSubscribed) {
            emit(AuthNavigationRequired(route: Routes.HOME));
          } else {
            emit(AuthNavigationRequired(route: Routes.PAYMENT_PLAN));
          }
        });
      }
    } else {
      emit(AuthNavigationRequired(route: Routes.SIGN_UP));
    }
  }

  Future<void> _onTrialStatusChecked(
    AuthTrialStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      emit(AuthAuthenticated(
        loginResponse: currentState.loginResponse,
        isTrialActive: currentState.isTrialActive,
        isSubscribed: event.isSubscribed,
      ));
    }
  }

  Future<void> _onSplashInitialized(
    AuthSplashInitialized event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    // Initialize device ID
    await _getId();
    
    // Initialize socket connection
    _socketRegister();
    
    // Wait for splash screen duration
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Check auth status
    await _checkAuthStatus(emit);
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      getStorageData.saveString(
          getStorageData.deviceId, iosDeviceInfo.identifierForVendor);
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      getStorageData.saveString(getStorageData.deviceId, androidDeviceInfo.id);
      return androidDeviceInfo.id;
    }
    return null;
  }

  void _socketRegister() {
    printAction("-==-=-= socket connecting");
    Constants.socket = IO.io(
      Constants.socketBaseUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'upgraded': ['websocket'],
        'autoConnect': true,
      },
    );

    // Socket event handlers
    Constants.socket!.onConnect((data) => _checkSocket(data, "onConnect"));
    Constants.socket!.on('connecting', (data) => _checkSocket(data, "onConnecting"));
    Constants.socket!.on('connect_timeout', (data) => _checkSocket(data, "onConnectTimeout"));
    Constants.socket!.onConnectError((data) => _checkSocket(data, "onConnectError"));
    Constants.socket!.onDisconnect((data) => _checkSocket(data, "onDisconnect"));
  }

  void _checkSocket(data, String identify) {
    if (identify == 'onConnect') {
      printOkStatus(" <<< ---------- Socket $identify ---------- >>>");
    } else {
      printError(" <<< ---------- Socket $identify ---------- >>>");
    }
  }

  Future<void> _checkAuthStatus(Emitter<AuthState> emit) async {
    final token = getStorageData.readString(getStorageData.tokenKey);

    if (token != null) {
      final email = getStorageData
          .readString(getStorageData.userEmailId)
          ?.toString()
          .toLowerCase();

      if (email == 'testing786@gmail.com') {
        emit(AuthNavigationRequired(route: Routes.HOME));
        return;
      }

      final isPinCreated =
          getStorageData.readBoolean(key: getStorageData.isPinCreated);

      final loginData = getStorageData.readLoginData();
      final createdAtString = loginData.data?.createdAt;
      final createdAt = DateTime.tryParse(createdAtString ?? "");

      if (createdAt != null) {
        final now = DateTime.now();
        final trialEndDate = createdAt.add(const Duration(seconds: 10));

        if (now.isBefore(trialEndDate)) {
          // Within trial period
          emit(AuthNavigationRequired(route: Routes.HOME));
          return;
        }
      }

      // Trial completed
      if (isPinCreated) {
        emit(AuthNavigationRequired(route: Routes.PIN_VERIFICATION));
      } else {
        _paymentPlanController.isUserSubscribedToProduct((isSubscribed) {
          if (isSubscribed) {
            emit(AuthNavigationRequired(route: Routes.HOME));
          } else {
            emit(AuthNavigationRequired(route: Routes.PAYMENT_PLAN));
          }
        });
      }
    } else {
      emit(AuthNavigationRequired(route: Routes.SIGN_UP));
    }
  }
}
