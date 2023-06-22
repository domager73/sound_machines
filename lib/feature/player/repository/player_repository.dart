import 'package:rxdart/rxdart.dart';
import 'dart:developer';
import 'package:sound_machines/utils/constants.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../models/track.dart';
import '../../../servise/music_service.dart';

class PlayerRepository {
  final MusicService musicService;

  PlayerRepository({required this.musicService}) : super() {
    allChanges();
    stateChanges();
    positionChanges();
    durationChanges();
    playerStream.stream.listen((event) {
      print(event);
    });
  }

  BehaviorSubject<LoadingStateEnum> trackDataLoadingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  BehaviorSubject<TrackData?> playerStream =
      BehaviorSubject<TrackData?>.seeded(null);
  BehaviorSubject<List<Track>> trackChanges =
      BehaviorSubject<List<Track>>.seeded([]);
  BehaviorSubject<String?> playlistChanges = BehaviorSubject<String?>.seeded(null);

  AudioPlayer audioPlayer = AudioPlayer();
  late TrackData trackStreamData;
  Track? trackData;
  List<Track>? queue;
  int currentTrack = 0;
  bool isPlaying = false;
  bool skipping = false;
  String? currentPlayListId;

  Future loadQueue() async {
    queue = await musicService.getAllTracks();
    trackChanges.add(queue ?? []);
  }

  void nextTrack() async {
    queue?[currentTrack].isPlay = false;
    currentTrack < queue!.length - 1 ? currentTrack++ : currentTrack = 0;
    trackData = queue?[currentTrack];
    queue?[currentTrack].isPlay = true;
    trackChanges.add(queue!);
    trackStreamData = TrackData(
        timeData:
            TrackTimeData(duration: Duration.zero, position: Duration.zero),
        data: trackData!,
        isPlaying: false);
    playerStream.add(trackStreamData);
    audioPlayer.play(UrlSource(trackData!.audioUrl));
  }

  void previousTrack() {
    queue?[currentTrack].isPlay = false;
    currentTrack > 0 ? currentTrack-- : currentTrack = queue!.length - 1;
    trackData = queue?[currentTrack];
    queue?[currentTrack].isPlay = true;
    trackChanges.add(queue!);
    trackStreamData = TrackData(
        timeData:
            TrackTimeData(duration: Duration.zero, position: Duration.zero),
        data: trackData!,
        isPlaying: false);
    playerStream.add(trackStreamData);
    audioPlayer.play(UrlSource(trackData!.audioUrl));
  }

  void seek15next() async {
    if (!skipping) {
      if (trackStreamData.timeData.position.inSeconds <
          trackStreamData.timeData.duration.inSeconds - 15) {
        skipping = true;
        await audioPlayer.seek(Duration(
            seconds: trackStreamData.timeData.position.inSeconds + 14));
        skipping = false;
      } else {
        nextTrack();
      }
    }
  }

  void seek15previous() async {
    if (!skipping) {
      if (trackStreamData.timeData.position.inSeconds > 15) {
        skipping = true;
        await audioPlayer.seek(Duration(
            seconds: trackStreamData.timeData.position.inSeconds - 14));
        skipping = false;
      } else {
        previousTrack();
      }
    }
  }

  void allChanges() async {}

  void stateChanges() async {
    audioPlayer.onPlayerStateChanged.listen((event) {
      isPlaying = event == PlayerState.playing;
      playerStream.add(trackStreamData.copyWithPlaying(isPlaying));
      log(isPlaying.toString());
    });
  }

  void durationChanges() async {
    audioPlayer.onDurationChanged.listen((event) {
      if (event.inSeconds > 0) {
        trackStreamData.data = trackData!;
        trackStreamData.timeData =
            trackStreamData.timeData.copyWithDuration(event);
        playerStream.add(trackStreamData);
        print('-----------------------------------${event.inSeconds}');
      }
    });
  }

  void positionChanges() async {
    audioPlayer.onPositionChanged.listen((event) async {
      trackStreamData.data = trackData!;
      trackStreamData.timeData =
          trackStreamData.timeData.copyWithPosition(event);
      trackStreamData.timeData = trackStreamData.timeData
          .copyWithDuration(await audioPlayer.getDuration() ?? Duration.zero);
      //print(trackStreamData);
      playerStream.add(trackStreamData);
    });
  }

  void setNewPlaylist(String? playlistId, List<Track> newQueue, {int index = 0}) async {
    queue = newQueue;
    final track = queue![index];
    currentTrack = track.id;
    trackData = queue?[track.id];
    queue?[track.id].isPlay = true;
    trackChanges.add(queue!);
    trackStreamData = TrackData(
        timeData:
        TrackTimeData(duration: Duration.zero, position: Duration.zero),
        data: track,
        isPlaying: false);
    playerStream.add(trackStreamData);
    await audioPlayer.play(UrlSource(track.audioUrl));
    currentPlayListId = playlistId;
    playlistChanges.add(playlistId);
    trackDataLoadingState.add(LoadingStateEnum.success);
  }

  void initialLoad() async {
    trackDataLoadingState.add(LoadingStateEnum.loading);
    try {
      await loadQueue();
      //setTrack(queue!.first, f: false);
      trackDataLoadingState.add(LoadingStateEnum.success);
    } catch (e) {
      trackDataLoadingState.add(LoadingStateEnum.fail);
    }
  }

  Future setTrack(Track track, {bool f = true}) async {
    if (trackData?.id != track.id) {
      queue?[currentTrack].isPlay = false;
      currentTrack = track.id;
      trackData = queue?[track.id];
      queue?[track.id].isPlay = true;
      trackChanges.add(queue!);
      trackStreamData = TrackData(
          timeData:
              TrackTimeData(duration: Duration.zero, position: Duration.zero),
          data: track,
          isPlaying: false);
      playerStream.add(trackStreamData);
      f
          ? await audioPlayer.play(UrlSource(track.audioUrl))
          : await audioPlayer.setSourceUrl(track.audioUrl);
    } else {
      await audioPlayer.resume();
    }
  }
}

class TrackData {
  Track data;
  TrackTimeData timeData;
  bool isPlaying;

  TrackData(
      {required this.timeData, required this.data, required this.isPlaying});

  TrackData copyWithTTD(TrackTimeData trackTimeData) {
    return TrackData(timeData: trackTimeData, data: data, isPlaying: isPlaying);
  }

  TrackData copyWithPlaying(bool playing) {
    return TrackData(timeData: timeData, data: data, isPlaying: playing);
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
