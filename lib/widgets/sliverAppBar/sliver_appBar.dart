import 'package:flutter/material.dart';
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
  final bool isPlayList;

  const AppBarWidget({
    Key? key,
    required this.text,
    required this.imagePath,
    required this.isButtonPlay,
    required this.expandedHeight,
    required this.isPlayList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<PlayerRepository>(context);

    return SliverAppBar(
      title: Text(
        text,
        style: AppTypography.font32fff,
      ),
      backgroundColor: Colors.transparent,
      centerTitle: false,
      expandedHeight: expandedHeight,
      pinned: true,
      elevation: 0,
      flexibleSpace:FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: StreamBuilder(
          stream: repository.playerStream,
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover
                ),
              ),
              child: !repository.isPlaying && isPlayList ? Column(
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
                              repository.setTrack(repository.queue![0]);
                            },
                          ),
                          const Text('Слушать', style: AppTypography.font16fff,),
                        ],
                      ),
                    ],
                  )
                ],
              ) : Container(),
            );
          }
        ),
      )
    );
  }
}
