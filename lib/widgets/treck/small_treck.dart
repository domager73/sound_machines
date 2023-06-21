import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';
import 'package:sound_machines/utils/colors.dart';

import '../../feature/player/ui/player_screen.dart';
import '../../models/track.dart';
import '../../utils/fonts.dart';

class SmallTrekScreen extends StatefulWidget {
  final Track track;

  const SmallTrekScreen({super.key, required this.track});

  @override
  State<SmallTrekScreen> createState() => _SmallTrekScreenState();
}

class _SmallTrekScreenState extends State<SmallTrekScreen> {
  @override
  Widget build(BuildContext context) {
    final repository =RepositoryProvider.of<PlayerRepository>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: widget.track.isPlay ? AppColors.playerBackgroundColor : AppColors.blackColor
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Row(
                children: [
                  Image(
                    image: widget.track.imageUrl == ''
                        ? const AssetImage('Assets/image_not_found.jpg')
                            as ImageProvider
                        : NetworkImage(widget.track.imageUrl),
                    height: 50,
                    width: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      widget.track.name,
                      style: AppTypography.font20fff,
                    ),
                  ),
                ],
              ),
              onTap: () {
                repository.setTrack(widget.track);
                print('-------------------------------');
                print(repository.trackData!.name);
                print('-------------------------------');
                //Navigator.of(context).push(_createRoute());
              },
            ),
            const InkWell(
              child: Icon(
                Icons.heart_broken_outlined,
                color: Colors.white,
                size: 25,
              ),
            ),
            // InkWell(
            //   onTap: () {
            //   },
            //   child: Icon(
            //     widget.track.isPlay ? Icons.pause : Icons.play_arrow,
            //     color: Colors.white,
            //     size: 30,
            //   ),
            // ),
          ],
        ),
      ),
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
      const curve = Curves.easeInCirc;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
