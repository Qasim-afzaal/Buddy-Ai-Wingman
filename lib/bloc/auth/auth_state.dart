import 'package:equatable/equatable.dart';
import 'package:buddy/pages/auth/login/login_response.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final LoginResponse loginResponse;
  final bool isTrialActive;
  final bool isSubscribed;

  const AuthAuthenticated({
    required this.loginResponse,
    required this.isTrialActive,
    required this.isSubscribed,
  });

  @override
  List<Object?> get props => [loginResponse, isTrialActive, isSubscribed];
}

class AuthUnauthenticated extends AuthState {}

class AuthTrialExpired extends AuthState {
  final LoginResponse loginResponse;
  final bool isSubscribed;

  const AuthTrialExpired({
    required this.loginResponse,
    required this.isSubscribed,
  });

  @override
  List<Object?> get props => [loginResponse, isSubscribed];
}

class AuthEmailVerificationSent extends AuthState {
  final String email;

  const AuthEmailVerificationSent({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthNavigationRequired extends AuthState {
  final String route;
  final Map<String, dynamic>? arguments;

  const AuthNavigationRequired({
    required this.route,
    this.arguments,
  });

  @override
  List<Object?> get props => [route, arguments];
}
