import 'package:flutter/material.dart';
import 'package:sound_machines/feature/home_screen/data/playlists_repository.dart';
import 'package:sound_machines/feature/main/bloc/navigation_cubit.dart';
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

  const AppBarWidget({
    Key? key,
    required this.text,
    required this.imagePath,
    required this.isButtonPlay,
    required this.expandedHeight,
    this.canBack = false,
    required this.isPlayList
  }) : super(key: key);

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
            canBack ? IconButton(onPressed: () {
              BlocProvider.of<NavigationCubit>(context).viewMain();
            },
                icon: const Icon(
                  Icons.arrow_back, color: Colors.white, size: 25,)) : Container(),
            Text(
              text,
              style: AppTypography.font32fff,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        centerTitle: false,
        expandedHeight: expandedHeight,
        pinned: true,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: StreamBuilder(
            stream: repository.playlistChanges,
            builder: (context, snapshot) =>
            repository.currentPlayListId ==
                playlistRepository.currentPlaylist
                ? StreamBuilder(
                stream: repository.playerStream,
                builder: (context, snapshot) {
                  return Container(
                      padding: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imagePath.contains('Assets/')
                                ? AssetImage(imagePath)
                                : NetworkImage(imagePath) as ImageProvider,
                            fit: BoxFit.cover),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
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
                                  const Text(
                                    'Слушать',
                                    style: AppTypography.font16fff,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ));
                })
                : Container(
                padding: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imagePath.contains('Assets/')
                          ? AssetImage(imagePath)
                          : NetworkImage(imagePath) as ImageProvider,
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              child: const Icon(
                                Icons.play_circle,
                                size: 100,
                                color: AppColors.playColor,
                              ),
                              onTap: () {
                                playAndPause();
                              },
                            ),
                            const Text(
                              'Слушать',
                              style: AppTypography.font16fff,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ));
  }
}
