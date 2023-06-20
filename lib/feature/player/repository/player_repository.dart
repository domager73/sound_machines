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

  void initialLoad() async {
    trackDataLoadingState.add(LoadingStateEnum.loading);
    try {
      trackData = await musicService.getLastTrack();
      trackDataLoadingState.add(LoadingStateEnum.success);
    } catch (e) {
      trackDataLoadingState.add(LoadingStateEnum.fail);
    }
  }
}
