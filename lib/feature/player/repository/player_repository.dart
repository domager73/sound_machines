import 'package:rxdart/rxdart.dart';
import 'package:sound_machines/utils/constants.dart';

import '../../../models/track.dart';
import '../../../servise/music_service.dart';

class PlayerRepository {
  final MusicService musicService;

  PlayerRepository({required this.musicService});

  BehaviorSubject<LoadingStateEnum> trackDataLoadingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  Track? trackData;
  List<Track>? queue;
  int currentTrack = 0;

  Future loadQueue() async {
    queue = await musicService.getAllTracks();
    queue = queue!.reversed.toList();
  }

  void nextTrack() {
    trackDataLoadingState.add(LoadingStateEnum.loading);
    if (currentTrack < queue!.length - 1) {
      currentTrack += 1;
      trackData = queue?[currentTrack];
    } else {
      currentTrack = 0;
      trackData = queue?[0];
    }
    print(currentTrack);
    print(queue?.length);
    print(trackData?.name);
    trackDataLoadingState.add(LoadingStateEnum.success);
  }
  void previousTrack() {
    trackDataLoadingState.add(LoadingStateEnum.loading);
    if (currentTrack > 0) {
      currentTrack -= 1;
      trackData = queue?[currentTrack];
    } else {
      currentTrack = queue!.length - 1;
      trackData = queue?[currentTrack];
    }
    trackDataLoadingState.add(LoadingStateEnum.success);
  }

  void initialLoad() async {
    trackDataLoadingState.add(LoadingStateEnum.loading);
    try {
      await loadQueue();
      trackData = queue?.first;
      trackDataLoadingState.add(LoadingStateEnum.success);

    } catch (e) {
      trackDataLoadingState.add(LoadingStateEnum.fail);
    }
  }
}
