import 'package:flutter/material.dart';
import 'package:sound_machines/models/playlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/utils/fonts.dart';

import '../../feature/home_screen/data/playlists_repository.dart';

// ignore: must_be_immutable
class PlaylistWidget extends StatelessWidget {
  PlaylistWidget({super.key, required this.playlist});

  Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.47;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              RepositoryProvider.of<PlaylistRepository>(context).playlistData = playlist;
              RepositoryProvider.of<PlaylistRepository>(context).loadPlaylistTracks(playlistId: playlist.id);
              Navigator.pushNamed(context, '/playList_screen');
            },
            child: Container(
              width: width,
              height: width - 10,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(playlist.imageUrl), fit: BoxFit.cover)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              playlist.name,
              style: AppTypography.font20fff,
            ),
          )
        ],
      ),
    );
  }
}
