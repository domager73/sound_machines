part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AppAuthState extends AppState {}

class AppUnAuthState extends AppState {}
