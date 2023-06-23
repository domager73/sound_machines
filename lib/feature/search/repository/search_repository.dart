import 'package:rxdart/rxdart.dart';
import 'package:sound_machines/utils/constants.dart';

import '../../../models/playlist.dart';
import '../../../models/track.dart';
import '../../../servise/music_service.dart';

class SearchRepository {
  final MusicService musicService;
  List<Track>? tracks = [];
  List<Track>? searchTracks = [];
  List<Playlist>? playLists = [];
  List<Playlist>? searchPLayList = [];
  String textController = '';

  SearchRepository({required this.musicService});

  BehaviorSubject<LoadingStateEnum> searchLoadingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  void loadTracks() async {
    tracks = await musicService.getAllTracks();
  }

  void loadPlayList() async {
    playLists = await musicService.loadPlaylists();
  }

  void initialLoadTracks() async {
    searchLoadingState.add(LoadingStateEnum.loading);
    try {
      loadTracks();
      loadPlayList();
      searchLoadingState.add(LoadingStateEnum.success);
    } catch (e) {
      searchLoadingState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  void searchTracksByName(String str) {
    searchLoadingState.add(LoadingStateEnum.loading);

    if (str.isEmpty) {
      searchTracks = [];
      searchLoadingState.add(LoadingStateEnum.success);
      return;
    }

    List<Track> resTracks = [];
    for (var i = 0; i < tracks!.length; i++) {
      if (tracks![i].name.toLowerCase().contains(str.toLowerCase())) {
        resTracks.add(tracks![i]);
      }
    }
    searchTracks = resTracks;

    searchLoadingState.add(LoadingStateEnum.success);
  }

  void searchPlayListByName(String str) {
    searchLoadingState.add(LoadingStateEnum.loading);

    if (str.isEmpty) {
      searchPLayList = [];
      searchLoadingState.add(LoadingStateEnum.success);
      return;
    }

    List<Playlist> resPlayList = [];
    for (var i = 0; i < playLists!.length; i++) {
      if (playLists![i].name.toLowerCase().contains(str.toLowerCase())) {
        resPlayList.add(playLists![i]);
      }
    }
    searchPLayList = resPlayList;

    searchLoadingState.add(LoadingStateEnum.success);
  }

  void setTextController(String str) {
    textController = str;
  }
}
