import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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

  BehaviorSubject<TrackData?> playerStream = BehaviorSubject<TrackData?>.seeded(null);

  AudioPlayer audioPlayer = AudioPlayer();
  late TrackData trackStreamData;
  Track? trackData;
  List<Track>? queue;
  int currentTrack = 0;

  Future loadQueue() async {
    queue = await musicService.getAllTracks();
  }

  void nextTrack() async  {
    currentTrack < queue!.length - 1 ? currentTrack++ : currentTrack = 0;
    trackData = queue?[currentTrack];
    trackStreamData = TrackData(timeData: TrackTimeData(duration: Duration.zero, position: Duration.zero), data: trackData!);
    playerStream.add(trackStreamData);
    audioPlayer.play(UrlSource(trackData!.audioUrl));
  }

  void previousTrack() {
    currentTrack > 0 ? currentTrack-- : currentTrack = queue!.length - 1;
    trackData = queue?[currentTrack];
    trackStreamData = TrackData(timeData: TrackTimeData(duration: Duration.zero, position: Duration.zero), data: trackData!);
    playerStream.add(trackStreamData);
    audioPlayer.play(UrlSource(trackData!.audioUrl));
  }

  void allChanges() async {
    audioPlayer.eventStream.listen((event) {
      print(event.eventType);
      if (event.eventType == AudioEventType.duration) print(event.duration?.inSeconds);
    });
  }

  void durationChanges() async {
    audioPlayer.onDurationChanged.listen((event) {
      if (event.inSeconds > 0) {
        trackStreamData.data = trackData!;
        trackStreamData.timeData = trackStreamData.timeData.copyWithDuration(event);
        playerStream.add(trackStreamData);
        print('-----------------------------------${event.inSeconds}');
      }
    });
  }

  void positionChanges() async {
    audioPlayer.onPositionChanged.listen((event) async {
      trackStreamData.data = trackData!;
      trackStreamData.timeData = trackStreamData.timeData.copyWithPosition(event);
      trackStreamData.timeData = trackStreamData.timeData.copyWithDuration(await audioPlayer.getDuration() ?? Duration.zero);
      //print(trackStreamData);
      playerStream.add(trackStreamData);
    });
  }

  void initialLoad() async {
    trackDataLoadingState.add(LoadingStateEnum.loading);
    try {
      await loadQueue();
      setTrack(queue!.first, f: false);
      trackDataLoadingState.add(LoadingStateEnum.success);
      allChanges();
      positionChanges();
      durationChanges();
      playerStream.stream.listen((event) {
        print(event);
      });
    } catch (e) {
      trackDataLoadingState.add(LoadingStateEnum.fail);
    }
  }

  void setTrack(Track track, {bool f = true}){
    if (trackData?.id != track.id) {
      currentTrack = track.id;
      trackData = queue?[track.id];
      trackStreamData = TrackData(timeData: TrackTimeData(duration: Duration.zero, position: Duration.zero), data: track);
      playerStream.add(trackStreamData);
      f? audioPlayer.play(UrlSource(track.audioUrl)) : audioPlayer.setSourceUrl(track.audioUrl);
    } else {
      audioPlayer.resume();
    }

  }
}


class TrackData {
  Track data;
  TrackTimeData timeData;

  TrackData({required this.timeData, required this.data});

  TrackData copyWithTTD(TrackTimeData trackTimeData) {
    return TrackData(timeData: trackTimeData, data: data);
  }

  @override
  String toString() =>
      '------------------------------------\n\nname: ${data.name} \n image: ${data.imageUrl} \n audio: ${data.audioUrl} \n duration: ${timeData.duration.inSeconds} \n position: ${timeData.position.inSeconds}\n\n---------------------';
}

class TrackTimeData {
  Duration duration;
  Duration position;

  TrackTimeData({required this.duration, required this.position});

  TrackTimeData copyWithPosition(Duration newPosition) {
    return TrackTimeData(duration: duration, position: newPosition);
  }

  TrackTimeData copyWithDuration(Duration newDuration) {
    return TrackTimeData(duration: newDuration, position: position);
  }
}