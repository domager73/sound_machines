part of 'playlist_tracks_cubit.dart';

@immutable
abstract class PlaylistTracksState {}

class PlaylistTracksInitial extends PlaylistTracksState {}

class PlaylistTracksLoadingState extends PlaylistTracksState {}

class PlaylistTracksSuccessState extends PlaylistTracksState {}

class PlaylistTrackFailState extends PlaylistTracksState {}
