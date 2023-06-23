import 'package:sound_machines/servise/music_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_machines/utils/constants.dart';

import '../../../models/playlist.dart';
import '../../../models/track.dart';

class PlaylistRepository {
  final MusicService musicService;

  static const homeScreenMixedTracksId = 'mixedTracks';
  static const searchScreenTracksId = 'searchTracks';
  static const playlistScreenTracksId = 'playlistTracks';

  PlaylistRepository({required this.musicService});

  BehaviorSubject<LoadingStateEnum> playlistsLoadingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);
  BehaviorSubject<LoadingStateEnum> tracksLoadingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  String? currentPlaylist;
  List<Playlist>? playlists;
  List<Track>? tracks = [];
  List<Track>? mixedTracks = [];
  Playlist? playlistData;

  List<Track> getCurrentQueue(
      {String type = playlistScreenTracksId, required Track? playingTrack}) {
    if (type == playlistScreenTracksId) {
      return playingTrack != null ? markPlayedTracks(playingTrack, tracks ?? []) : tracks ?? [];
    } else if (type == homeScreenMixedTracksId) {
      return playingTrack != null ? markPlayedTracks(playingTrack, mixedTracks ?? []) : mixedTracks ?? [];
    } else {
      return [];
    }
  }

  static List<String> getTracksIds(List<Track> t) {
    List<String> ids = [];
    for (var i in t) {
      ids.add(i.firebaseId);
    }

    return ids;
  }

  static List<Track> markPlayedTracks(
      Track playingTrack, List<Track> needToMark) {
    final List<String> currentIds = getTracksIds(needToMark);
    needToMark = clearPlayingStates(needToMark);

    if (currentIds.contains(playingTrack.firebaseId)) {
      final ind = currentIds.indexOf(playingTrack.firebaseId);
      needToMark[ind].isPlay = true;
    }

    return needToMark;
  }

  static List<Track> clearPlayingStates(List<Track> toClear) {
    for (var i = 0; i < toClear.length; i++) {
      toClear[i].isPlay = false;
    }
    return toClear;
  }

  void loadPlaylists() async {
    playlistsLoadingState.add(LoadingStateEnum.loading);
    try {
      playlists = await musicService.loadPlaylists();
      mixedTracks = await musicService.getAllTracks();
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
