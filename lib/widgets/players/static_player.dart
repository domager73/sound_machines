import 'package:flutter/material.dart';

import '../../feature/player/ui/player_screen.dart';
import '../../models/track.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';

class StaticPLayer extends StatefulWidget {
  final Track track;

  const StaticPLayer({super.key, required this.track});

  @override
  State<StaticPLayer> createState() => _StaticPLayerState();
}

class _StaticPLayerState extends State<StaticPLayer> {
  @override
  Widget build(BuildContext context) {
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
                    Image(
                      image: widget.track.imageUrl.isNotEmpty
                          ? NetworkImage(widget.track.imageUrl)
                          : const AssetImage('Assets/image_not_found.jpg')
                              as ImageProvider,
                      width: 50,
                      height: 50,
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
                onTap: () {},
                child: const Icon(
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
