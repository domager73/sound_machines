part of 'navigation_cubit.dart';

@immutable
abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class PlaylistScreenState extends NavigationState {}

class MainScreenState extends NavigationState {}