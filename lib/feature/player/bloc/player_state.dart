part of 'player_bloc.dart';

@immutable
abstract class PlayerState {}

class PlayerInitial extends PlayerState {}

class TrackLoadedState extends PlayerState {}

class PlayerLoadingState extends PlayerState {}

class TrackLoadFailState extends PlayerState {}