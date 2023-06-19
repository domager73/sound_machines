part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class AppSubscribe extends AppEvent {}

class LogoutEvent extends AppEvent {}

class AppAuthEvent extends AppEvent {}

class AppUnAuthEvent extends AppEvent {}