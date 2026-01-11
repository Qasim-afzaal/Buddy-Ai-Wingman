import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthSignupRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const AuthSignupRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, password];
}

class AuthSocialLoginRequested extends AuthEvent {
  final String email;
  final String authProvider;
  final String? firstName;
  final String? lastName;
  final String? profileImageUrl;

  const AuthSocialLoginRequested({
    required this.email,
    required this.authProvider,
    this.firstName,
    this.lastName,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [email, authProvider, firstName, lastName, profileImageUrl];
}

class AuthPinLoginRequested extends AuthEvent {
  final String pin;

  const AuthPinLoginRequested({required this.pin});

  @override
  List<Object?> get props => [pin];
}

class AuthEmailVerificationRequested extends AuthEvent {
  final String email;

  const AuthEmailVerificationRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatusRequested extends AuthEvent {}

class AuthTrialStatusChecked extends AuthEvent {
  final bool isSubscribed;

  const AuthTrialStatusChecked({required this.isSubscribed});

  @override
  List<Object?> get props => [isSubscribed];
}

class AuthSplashInitialized extends AuthEvent {}
