part of 'player_bloc.dart';

@immutable
abstract class PlayerEvent {}

class PlayerSubscribe extends PlayerEvent {}

class InitialLoadEvent extends PlayerEvent {}

class PlayerLoadingEvent extends PlayerEvent {}

class TrackLoadedEvent extends PlayerEvent {}

class TrackLoadFailEVent extends PlayerEvent {}