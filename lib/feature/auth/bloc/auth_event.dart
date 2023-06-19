part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthSubscribe extends AuthEvent {}

class AuthWithGoogleEvent extends AuthEvent {}

class AuthWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  AuthWithEmailEvent({required this.email, required this.password});
}

class RegisterWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  RegisterWithEmailEvent({required this.email, required this.password, required this.name});
}

class AuthLoadingEvent extends AuthEvent {}

class AuthSuccessEvent extends AuthEvent {}

class AuthFailEvent extends AuthEvent {}
