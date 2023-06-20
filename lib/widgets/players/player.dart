import 'dart:math';

import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';

import '../../utils/utils.dart';

class CustomPlayer extends StatefulWidget {
  CustomPlayer(
      {super.key,
      required this.name,
      required this.audioUrl,
      required this.imageUrl,
      required this.audioPlayer});

  String name;
  String audioUrl;
  String imageUrl;
  final audioPlayer;

  @override
  State<CustomPlayer> createState() => _CustomPlayerState();
}

class _CustomPlayerState extends State<CustomPlayer> {
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    widget.audioPlayer.play(UrlSource(widget.audioUrl));
    widget.audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    widget.audioPlayer.onDurationChanged.listen((newDuration) {
      print(newDuration.toString());
      setState(() {
        duration = newDuration;
      });
    });

    widget.audioPlayer.onPositionChanged.listen((newPosition) {
      print("pos: $newPosition");
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    widget.audioPlayer.dispose();
    super.dispose();
  }

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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                textAlign: TextAlign.center, style: AppTypography.font32fff),
            Column(
              children: [
                Slider(
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final positionValue = Duration(seconds: value.toInt());
                    await widget.audioPlayer.seek(positionValue);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    RepositoryProvider.of<PlayerRepository>(context)
                        .previousTrack();
                  },
                  child: const Icon(
                    Icons.skip_previous,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    isPlaying
                        ? await widget.audioPlayer.pause()
                        : await widget.audioPlayer.resume();

                    isPlaying = !isPlaying;
                  },
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    RepositoryProvider.of<PlayerRepository>(context)
                        .nextTrack();
                  },
                  child: const Icon(
                    Icons.skip_next,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
