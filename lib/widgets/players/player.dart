import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';

import '../../utils/utils.dart';

class CustomPlayer extends StatefulWidget {
  CustomPlayer({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  String name;
  String imageUrl;

  @override
  State<CustomPlayer> createState() => _CustomPlayerState();
}

class _CustomPlayerState extends State<CustomPlayer> {
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool prepared = false;

  String formatTime(Duration duration) {
    String toDigits(int n) => n.toString().padLeft(2, '0');
    final hours = toDigits(duration.inHours);
    final minutes = toDigits(duration.inMinutes);
    final second = toDigits(duration.inSeconds % 60);

    return [
      if (duration.inHours > 0) hours,
      minutes,
      second,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<PlayerRepository>(context);

    void setZeroDuration() {
      setState(() {
        position = Duration.zero;
        duration = Duration.zero;
        prepared = false;
        print(position.inSeconds);
      });
    }

    void nextTrack() async {
      await repository.audioPlayer.stop();
      setZeroDuration();
      repository.nextTrack();
    }

    void previousTrack() async {
      await repository.audioPlayer.stop();
      setZeroDuration();
      repository.previousTrack();
    }

    repository.audioPlayer.onDurationChanged.listen((event) {duration = event;  if (duration.inSeconds > 0) prepared = true;});
    repository.audioPlayer.onPlayerStateChanged.listen((event) {setState(() {
      repository.trackData!.setIsPlay(event == PlayerState.playing);
    });});

    return StreamBuilder(
        stream: repository.audioPlayer.eventStream,
        initialData: const AudioEvent(eventType: AudioEventType.duration),
        builder: (context, snapshot) {
          print(snapshot.data!.eventType);
          if (snapshot.data!.eventType == AudioEventType.position) {
            position = snapshot.data!.position ?? Duration.zero;
          }
          if (snapshot.data!.eventType == AudioEventType.prepared) {
            widget.name = RepositoryProvider.of<PlayerRepository>(context)
                .trackData!
                .name;
            widget.imageUrl = RepositoryProvider.of<PlayerRepository>(context)
                .trackData!
                .imageUrl;
            print(prepared);
          }
          if (snapshot.data!.eventType == AudioEventType.complete) {
            if (prepared) {
              prepared = false;
              nextTrack();
            }
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.amber, Colors.black]),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        image: widget.imageUrl.isNotEmpty
                            ? NetworkImage(widget.imageUrl)
                            : const AssetImage('Assets/image_not_found.jpg')
                                as ImageProvider,
                        width: MediaQuery.of(context).size.height,
                        height: 300,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(widget.name,
                          textAlign: TextAlign.center,
                          style: AppTypography.font32fff),
                      Column(
                        children: [
                          Slider(
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.toDouble(),

                            onChanged: (value) async {
                              final positionValue =
                                  Duration(seconds: value.toInt());
                              await repository.audioPlayer.seek(positionValue);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatTime(position),
                                  style: AppTypography.font16fff,
                                ),
                                Text(formatTime(duration),
                                    style: AppTypography.font16fff),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 50, 8, 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onTap: () {},
                            ),
                            InkWell(
                              onTap: () async {
                                previousTrack();
                              },
                              child: const Icon(
                                Icons.skip_previous,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            prepared
                                ? InkWell(
                                    onTap: () async {
                                      repository.trackData!.isPlay
                                          ? await repository.audioPlayer.pause()
                                          : await repository.audioPlayer
                                              .resume();

                                      repository.trackData!.setIsPlay(repository.trackData!.isPlay);
                                    },
                                    child: Icon(
                                      repository.trackData!.isPlay
                                          ? Icons.pause
                                          : Icons.play_arrow_rounded,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.offline_bolt),
                            InkWell(
                              onTap: () async {
                                nextTrack();
                              },
                              child: const Icon(
                                Icons.skip_next,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 25, 40, 15),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onTap: () {},
                            ),
                            InkWell(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
