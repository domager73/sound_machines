import 'package:flutter/material.dart';
import 'package:sound_machines/feature/home_screen/data/playlists_repository.dart';
import 'package:sound_machines/feature/player/bloc/player_bloc.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';
import 'package:sound_machines/utils/fonts.dart';

import '../../utils/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarWidget extends StatelessWidget {
  final String text;
  final String imagePath;
  final bool isButtonPlay;
  final double expandedHeight;
  final bool canBack;
  final bool isPlayList;

  const AppBarWidget(
      {Key? key,
      required this.text,
      required this.imagePath,
      required this.isButtonPlay,
      required this.expandedHeight,
      this.canBack = false,
      this.isPlayList = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<PlayerRepository>(context);
    final playlistRepository =
        RepositoryProvider.of<PlaylistRepository>(context);

    void playAndPause() async {
      if (repository.currentPlayListId != playlistRepository.currentPlaylist) {
        repository.setNewPlaylist(
            playlistRepository.currentPlaylist!, playlistRepository.tracks!);
      } else {
        repository.isPlaying
            ? repository.audioPlayer.pause()
            : repository.audioPlayer.resume();
      }
    }

    return SliverAppBar(
        title: Row(
          children: [
            canBack
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    ))
                : Container(),
            Text(
              text,
              style: AppTypography.font32fff,
            ),
          ],
        ),
        backgroundColor: AppColors.blackColor,
        centerTitle: false,
        expandedHeight: expandedHeight,
        pinned: true,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Container(
              padding: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: imagePath.contains('Assets/')
                        ? AssetImage(imagePath)
                        : NetworkImage(imagePath) as ImageProvider,
                    fit: BoxFit.cover),
              ),
              child: isPlayList
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            repository.currentPlayListId ==
                                    playlistRepository.currentPlaylist
                                ? StreamBuilder(
                                    stream: repository.playerStream,
                                    builder: (context, snapshot) {
                                      return Column(children: [
                                        InkWell(
                                          child: !repository.isPlaying
                                              ? const Icon(
                                                  Icons.play_circle,
                                                  size: 100,
                                                  color: AppColors.playColor,
                                                )
                                              : const Icon(
                                                  Icons.pause_circle,
                                                  size: 100,
                                                  color: AppColors.playColor,
                                                ),
                                          onTap: () {
                                            playAndPause();
                                          },
                                        ),
                                        Text(
                                          !repository.isPlaying
                                              ? 'Слушать'
                                              : 'Пауза',
                                          style: AppTypography.font16fff,
                                        ),
                                      ]);
                                    })
                                : Column(
                                    children: [
                                      InkWell(
                                        onTap: playAndPause,
                                        child: const Icon(
                                          Icons.play_circle,
                                          size: 100,
                                          color: AppColors.playColor,
                                        ),
                                      ),
                                      const Text(
                                        'Слушать',
                                        style: AppTypography.font16fff,
                                      ),
                                    ],
                                  )
                          ],
                        )
                      ],
                    )
                  : Container()),
        ));
  }
}
