import 'package:flutter/material.dart';

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
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  const Image(
                    image: AssetImage('Assets/image_not_found.jpg'),
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
                Navigator.of(context).push(_createRoute());
              },
            ),
            const InkWell(
              child: Icon(
                Icons.heart_broken_outlined,
                color: Colors.white,
                size: 25,
              ),
            ),
            const InkWell(
              child: Icon(
                Icons.play_arrow, color: Colors.white,
                size: 30,
              ),
            ),
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

