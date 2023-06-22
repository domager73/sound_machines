import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/home_screen/data/playlists_repository.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';
import 'package:sound_machines/utils/colors.dart';

import '../../feature/player/ui/player_screen.dart';
import '../../models/track.dart';
import '../../utils/fonts.dart';

class SmallTrekScreen extends StatefulWidget {
  final Track track;
  final bool notInPlaylist;

  const SmallTrekScreen(
      {super.key, required this.track, this.notInPlaylist = false});

  @override
  State<SmallTrekScreen> createState() => _SmallTrekScreenState();
}

class _SmallTrekScreenState extends State<SmallTrekScreen> {
  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<PlayerRepository>(context);
    final playlistRepository =
        RepositoryProvider.of<PlaylistRepository>(context);

    void setPlay(int? index) {
      if (playlistRepository.currentPlaylist == repository.currentPlayListId && repository.queue != null) {
        repository.setTrack(repository.queue![index ?? 0]);
      } else {
        if (widget.notInPlaylist) playlistRepository.currentPlaylist = null;
        repository.setNewPlaylist(
            playlistRepository.currentPlaylist,
            !widget.notInPlaylist
                ? playlistRepository.tracks!
                : playlistRepository.mixedTracks!,
            index: widget.track.id);
        setState(() {
          widget.track.isPlay = true;
        });
      }
    }

    return Container(
      decoration: BoxDecoration(

          color: widget.track.isPlay
              ? AppColors.currentTrackColor
              : AppColors.blackColor),
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
                setPlay(widget.track.id);
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
