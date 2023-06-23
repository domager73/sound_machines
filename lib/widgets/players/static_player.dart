import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';

import '../../feature/player/ui/player_screen.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';

class StaticPLayer extends StatefulWidget {
  const StaticPLayer({super.key});

  @override
  State<StaticPLayer> createState() => _StaticPLayerState();
}

class _StaticPLayerState extends State<StaticPLayer> {
  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<PlayerRepository>(context);
    return StreamBuilder(
      stream: repository.playerStream,
      builder: (context, snapshot) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.playerBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        Container(
                          width: 47,
                          height: 47,
                          decoration: BoxDecoration(image: DecorationImage(image: repository.trackData!.imageUrl.isNotEmpty
                              ? NetworkImage(repository.trackData!.imageUrl)
                              : const AssetImage('Assets/image_not_found.jpg')
                          as ImageProvider, fit: BoxFit.cover)),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width - 160,
                          child: Text(
                            repository.trackData!.name,
                            style: AppTypography.font20fff,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(_createRoute());
                    },
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.heart_broken_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      repository.isPlaying
                          ? repository.audioPlayer.pause()
                          : repository.audioPlayer.resume();
                    },
                    child: repository.isPlaying
                        ? const Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 30,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 30,
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const PlayerScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
