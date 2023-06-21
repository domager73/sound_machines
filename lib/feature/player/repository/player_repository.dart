import 'package:rxdart/rxdart.dart';
import 'package:sound_machines/utils/constants.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../models/track.dart';
import '../../../servise/music_service.dart';

class PlayerRepository {
  final MusicService musicService;

  PlayerRepository({required this.musicService});

  BehaviorSubject<LoadingStateEnum> trackDataLoadingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  AudioPlayer audioPlayer = AudioPlayer();
  Track? trackData;
  List<Track>? queue;
  int currentTrack = 0;

  Future loadQueue() async {
    queue = await musicService.getAllTracks();
    queue = queue!.reversed.toList();
  }

  void nextTrack() async  {
    if (currentTrack < queue!.length - 1) {
      currentTrack += 1;
      trackData = queue?[currentTrack];
    } else {
      currentTrack = 0;
      trackData = queue?[0];
    }
    audioPlayer.play(UrlSource(trackData!.audioUrl));
  }

  void previousTrack() {
    if (currentTrack > 0) {
      currentTrack -= 1;
      trackData = queue?[currentTrack];
    } else {
      currentTrack = queue!.length - 1;
      trackData = queue?[currentTrack];
    }
    audioPlayer.play(UrlSource(trackData!.audioUrl));
  }

  void initialLoad() async {
    trackDataLoadingState.add(LoadingStateEnum.loading);
    try {
      await loadQueue();
      trackData = queue?.first;
      trackDataLoadingState.add(LoadingStateEnum.success);
      audioPlayer.setSourceUrl(trackData!.audioUrl);
      audioPlayer.eventStream.listen((event) {
        print(event.eventType);
      });
    } catch (e) {
      trackDataLoadingState.add(LoadingStateEnum.fail);
    }
  }

  void setTrack(Track track){
    trackData = track;
    audioPlayer.play(UrlSource(trackData!.audioUrl));
    currentTrack = queue!.indexOf(track);
    print(currentTrack);
    print(trackData!.name);
  }
}
