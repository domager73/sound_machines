part of 'player_bloc.dart';

@immutable
abstract class PlayerBlocState {}

class PlayerInitial extends PlayerBlocState {}

class TrackLoadedState extends PlayerBlocState {}

class PlayerLoadingState extends PlayerBlocState {}

class TrackLoadFailState extends PlayerBlocState {}