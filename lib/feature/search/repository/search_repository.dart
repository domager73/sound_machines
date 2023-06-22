import 'package:rxdart/rxdart.dart';
import 'package:sound_machines/utils/constants.dart';

import '../../../models/track.dart';
import '../../../servise/music_service.dart';

class SearchRepository {
  final MusicService musicService;
  List<Track>? tracks = [];
  List<Track>? searchTracks = [];

  SearchRepository({required this.musicService});

  BehaviorSubject<LoadingStateEnum> searchLoadingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  BehaviorSubject<List<Track>> trackChanges =
      BehaviorSubject<List<Track>>.seeded([]);

  void loadTracks() async{
    tracks = await musicService.getAllTracks();
    trackChanges.add(tracks!);
  }

  void initialLoadTracks() async {
    searchLoadingState.add(LoadingStateEnum.loading);
    try {
      tracks = await musicService.getAllTracks();
      searchLoadingState.add(LoadingStateEnum.success);
    } catch (e) {
      searchLoadingState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  void searchTrackByCharElem(String str){
    searchLoadingState.add(LoadingStateEnum.loading);
    List<Track> resTracks = [];
    for(var i = 0; i < tracks!.length - 1; i++){
      if(tracks![i].name.contains(str)){
        resTracks.add(tracks![i]);
      }
    }
    searchTracks = resTracks;

    searchLoadingState.add(LoadingStateEnum.success);
  }
}
