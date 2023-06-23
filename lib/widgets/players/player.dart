import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';

import '../../utils/utils.dart';

class CustomPlayer extends StatefulWidget {
  CustomPlayer({
    super.key,
  });

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
    bool isPlaying = repository.audioPlayer.state == PlayerState.playing;

    void nextTrack() async {
      await repository.audioPlayer.stop();
      repository.nextTrack();
    }

    void previousTrack() async {
      await repository.audioPlayer.stop();
      repository.previousTrack();
    }

    repository.audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        nextTrack();
      }
      isPlaying = event == PlayerState.playing;
    });

    return StreamBuilder(
        stream: repository.playerStream,
        initialData: repository.trackStreamData,
        builder: (context, snapshot)  {
          if (snapshot.hasData && snapshot.data != null)  {
            duration = snapshot.data!.timeData.duration;
            position = snapshot.data!.timeData.position;
            if (duration.inSeconds > 0) {
              prepared = true;
            } else {
              prepared = false;
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
                          image: snapshot.data!.data.imageUrl.isNotEmpty
                              ? NetworkImage(snapshot.data!.data.imageUrl)
                              : const AssetImage('Assets/image_not_found.jpg')
                                  as ImageProvider,
                          width: MediaQuery.of(context).size.height,
                          height: 300,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(snapshot.data!.data.name,
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
                                await repository.audioPlayer
                                    .seek(positionValue);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                child: Image.asset('Assets/skip_15_prev.png', width: 24, height: 24,),
                                onTap: () async {repository.seek15previous();},
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
                                        isPlaying
                                            ? await repository.audioPlayer
                                                .pause()
                                            : await repository.audioPlayer
                                                .resume();
                                        setState(() {
                                        });
                                      },
                                      child: Icon(
                                        isPlaying
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
                                child: Image.asset('Assets/skip_15_next.png', width: 24, height: 24,),
                                onTap: () {repository.seek15next();},
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
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onTap: () {},
                              ),
                              InkWell(
                                child: const Icon(
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
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
