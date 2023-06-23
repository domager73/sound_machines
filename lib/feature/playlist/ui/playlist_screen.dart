import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/home_screen/data/playlists_repository.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';
import '../../../widgets/containers/small_treck.dart';
import '../../../widgets/players/static_player.dart';
import '../../../widgets/slivers/sliver_appBar.dart';
import '../../home_screen/bloc/playlist_tracks_cubit.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<PlayerRepository>(context);
    final playlistRepository =
        RepositoryProvider.of<PlaylistRepository>(context);

    void setPlay(int index) {
      if (playlistRepository.currentPlaylist == repository.currentPlayListId) {
        repository.setTrack(repository.queue![index]);
      } else {
        repository.setNewPlaylist(
            playlistRepository.currentPlaylist, playlistRepository.tracks!,
            index: index);
      }
    }

    return Scaffold(
      body: BlocBuilder<PlaylistTracksCubit, PlaylistTracksState>(
        builder: (context, state) {
          if (state is PlaylistTracksSuccessState) {
            return Stack(children: [
              CustomScrollView(
                slivers: <Widget>[
                  AppBarWidget(
                    text: playlistRepository.playlistData!.name,
                    imagePath:
                        playlistRepository.playlistData!.imageUrl.isNotEmpty
                            ? playlistRepository.playlistData!.imageUrl
                            : 'Assets/obl_pllist.webp',
                    isButtonPlay: true,
                    isPlayList: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  StreamBuilder(
                      stream: repository.playerStream,
                      builder: (context, snapshot) => SliverFixedExtentList(
                            delegate: SliverChildListDelegate(playlistRepository
                                .getCurrentQueue(
                                    playingTrack: repository.trackData)
                                .map((e) => SmallTrekScreen(
                                      track: e,
                                      onTap: setPlay,
                                    ))
                                .toList()),
                            itemExtent: 60,
                          )),
                ],
              ),
              StreamBuilder(
                stream: repository.playerStream,
                builder: (context, snapshot) => repository.trackData != null
                    ? const StaticPLayer()
                    : Container(),
              )
            ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
