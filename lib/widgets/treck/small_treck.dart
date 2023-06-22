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

  const SmallTrekScreen({super.key, required this.track});

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
      if (playlistRepository.currentPlaylist == repository.currentPlayListId) {
        repository.setTrack(repository.queue![index ?? 0]);
      } else {
        repository.setNewPlaylist(
            playlistRepository.currentPlaylist!, playlistRepository.tracks!,
            index: widget.track.id);
      }
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: widget.track.isPlay
              ? AppColors.playerBackgroundColor
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
          ],
        ),
      ),
    );
  }
}
