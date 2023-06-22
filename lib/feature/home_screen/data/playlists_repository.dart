import 'package:sound_machines/servise/music_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_machines/utils/constants.dart';

import '../../../models/playlist.dart';
import '../../../models/track.dart';

class PlaylistRepository {
  final MusicService musicService;

  PlaylistRepository({required this.musicService});

  BehaviorSubject<LoadingStateEnum> playlistsLoadingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);
  BehaviorSubject<LoadingStateEnum> tracksLoadingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  String? currentPlaylist;
  List<Playlist>? playlists;
  List<Track>? tracks;
  Playlist? playlistData;

  void loadPlaylists() async {
    playlistsLoadingState.add(LoadingStateEnum.loading);
    try {
      playlists = await musicService.loadPlaylists();
      playlistsLoadingState.add(LoadingStateEnum.success);
    } catch (e) {
      playlistsLoadingState.add(LoadingStateEnum.fail);
    }
  }

  void loadPlaylistTracks({required String playlistId}) async {
    tracksLoadingState.add(LoadingStateEnum.loading);
    try {
      currentPlaylist = playlistId;
      tracks = await musicService.getPlaylistTracks(playlistId);
      tracksLoadingState.add(LoadingStateEnum.success);
    } catch (e) {
      tracksLoadingState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

}


class NewQueue {
  String playlistId;
  List<Track> tracks;

  NewQueue({required this.playlistId, required this.tracks});
}