import 'package:flutter/material.dart';
import 'package:sound_machines/models/playlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistWidget extends StatelessWidget {
  PlaylistWidget({super.key, required this.playlist});
  Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.47;
    return InkWell(
      onTap: () async {

      },

      child: Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.red),
        width: width,
        height: width * 1.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: width * 0.8, height: width * 0.8, decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(playlist.imageUrl))),),
            Text(playlist.name, style: const TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
