import 'package:sound_machines/servise/music_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_machines/utils/constants.dart';

import '../../../models/playlist.dart';

class PlaylistRepository {
  final MusicService musicService;

  PlaylistRepository({required this.musicService});
  BehaviorSubject<LoadingStateEnum> playlistsLoadingState = BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  List<Playlist>? playlists;

  void loadPlaylists() async {
    playlistsLoadingState.add(LoadingStateEnum.loading);
    try {
      playlists = await musicService.loadPlaylists();
      playlistsLoadingState.add(LoadingStateEnum.success);
    } catch (e) {
      playlistsLoadingState.add(LoadingStateEnum.fail);
    }
  }
}