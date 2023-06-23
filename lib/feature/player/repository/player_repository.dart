import 'package:rxdart/rxdart.dart';
import 'dart:developer';
import 'package:sound_machines/utils/constants.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../models/time_data.dart';
import '../../../models/track.dart';
import '../../../models/track_data.dart';
import '../../../servise/music_service.dart';

class PlayerRepository {
  final MusicService musicService;

  PlayerRepository({required this.musicService}) : super() {
    stateChanges();
    positionChanges();
    durationChanges();
    playerStream.stream.listen((event) {
      log(event.toString());
    });
  }

  BehaviorSubject<LoadingStateEnum> trackDataLoadingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);
  BehaviorSubject<TrackData?> playerStream =
      BehaviorSubject<TrackData?>.seeded(null);
  BehaviorSubject<String?> playlistChanges =
      BehaviorSubject<String?>.seeded(null);

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
  }

  void nextTrack() async {
    queue?[currentTrack].isPlay = false;
    currentTrack < queue!.length - 1 ? currentTrack++ : currentTrack = 0;
    selectTrack(currentTrack);
    audioPlayer.play(UrlSource(trackData!.audioUrl));
  }

  void previousTrack() {
    queue?[currentTrack].isPlay = false;
    currentTrack > 0 ? currentTrack-- : currentTrack = queue!.length - 1;
    selectTrack(currentTrack);
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

  void stateChanges() async {
    audioPlayer.onPlayerStateChanged.listen((event) {
      isPlaying = event == PlayerState.playing;
      playerStream.add(trackStreamData.copyWithPlaying(isPlaying));
      if (event == PlayerState.completed) {
        nextTrack();
      }
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
      playerStream.add(trackStreamData);
    });
  }

  void selectTrack(int ind) {
    trackData = queue?[currentTrack];
    queue?[currentTrack].isPlay = true;
    trackStreamData = TrackData(
        timeData:
            TrackTimeData(duration: Duration.zero, position: Duration.zero),
        data: trackData!,
        isPlaying: false);
    playerStream.add(trackStreamData);
  }

  Future setNewPlaylist(String? playlistId, List<Track> newQueue,
      {int index = 0}) async {
    queue = newQueue;
    currentPlayListId = playlistId;
    currentTrack = index;

    selectTrack(currentTrack);
    await audioPlayer.play(UrlSource(queue![index].audioUrl));

    playlistChanges.add(playlistId);
    trackDataLoadingState.add(LoadingStateEnum.success);
  }

  void initialLoad() async {
    trackDataLoadingState.add(LoadingStateEnum.loading);
    try {
      await loadQueue();
      trackDataLoadingState.add(LoadingStateEnum.success);
    } catch (e) {
      trackDataLoadingState.add(LoadingStateEnum.fail);
    }
  }

  Future setTrack(Track track, {bool f = true, int? customId}) async {
    if (trackData?.id != (customId ?? track.id)) {
      queue?[currentTrack].isPlay = false;
      currentTrack = customId ?? track.id;
      selectTrack(currentTrack);
      f
          ? await audioPlayer.play(UrlSource(track.audioUrl))
          : await audioPlayer.setSourceUrl(track.audioUrl);
    } else {
      await audioPlayer.resume();
    }
  }
}
