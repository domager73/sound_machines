import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/utils/fonts.dart';

import '../../../bloc/app_bloc.dart';
import '../../../utils/colors.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.snackBarBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                BlocProvider.of<AppBloc>(context).add(LogoutEvent());
              },
              child: const Text(
                'Выйти',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage('Assets/spotify_img.png'),
                width: MediaQuery.of(context).size.height,
                height: 300,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text('name',
                  textAlign: TextAlign.center, style: AppTypography.font32fff),
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final positionValue = Duration(seconds: value.toInt());
                  await audioPlayer.seek(positionValue);

                  await audioPlayer.release();
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
                    Text(formatTime(duration - position),
                        style: AppTypography.font16fff),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  if(isPlaying){
                    await audioPlayer.stop();
                  }
                  else{
                    String sours =
                        'https://sound-pack.net/download/Sound_07024.mp3';
                    await audioPlayer.play(UrlSource(sours));
                  }

                  isPlaying = !isPlaying;
                },
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
