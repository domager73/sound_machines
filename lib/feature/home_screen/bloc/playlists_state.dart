part of 'playlists_cubit.dart';

@immutable
abstract class PlaylistsState {}

class PlaylistsInitial extends PlaylistsState {}

class PlaylistsLoadingState extends PlaylistsState {}

class PlaylistsSuccessState extends PlaylistsState {}

class PlaylistFailState extends PlaylistsState {}