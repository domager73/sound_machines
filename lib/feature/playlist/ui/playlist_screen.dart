import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/home_screen/data/playlists_repository.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';
import 'package:sound_machines/widgets/players/static_player.dart';
import '../../../widgets/slivers/sliver_appBar.dart';
import '../../../widgets/treck/small_treck.dart';
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

    return Scaffold(
      body: BlocBuilder<PlaylistTracksCubit, PlaylistTracksState>(
        builder: (context, state) {
          if (state is PlaylistTracksSuccessState) {
            return StreamBuilder(
                stream: repository.playerStream,
                builder: (context, snapshot) {
                  return Stack(children: [
                    CustomScrollView(
                      slivers: <Widget>[
                        AppBarWidget(
                          canBack: false,
                          text: playlistRepository.playlistData!.name,
                          imagePath: playlistRepository
                                  .playlistData!.imageUrl.isNotEmpty
                              ? playlistRepository.playlistData!.imageUrl
                              : 'Assets/obl_pllist.webp',
                          isButtonPlay: true,
                          isPlayList: true,
                          expandedHeight:
                              MediaQuery.of(context).size.height * 0.4,
                        ),
                        StreamBuilder(
                          stream: repository.playlistChanges,
                          builder: (context, snapshot) {
                            if (snapshot.data ==
                                playlistRepository.currentPlaylist) {
                              return StreamBuilder(
                                  stream: repository.trackChanges,
                                  initialData: repository.queue!,
                                  builder: (context, snapshot) {
                                    return SliverFixedExtentList(
                                      delegate:
                                          SliverChildListDelegate(snapshot.data!
                                              .map((e) => SmallTrekScreen(
                                                    track: e,
                                                  ))
                                              .toList()),
                                      itemExtent: 60,
                                    );
                                  });
                            } else {
                              return SliverFixedExtentList(
                                delegate: SliverChildListDelegate(
                                    playlistRepository.tracks!
                                        .map((e) => SmallTrekScreen(
                                              track: e,
                                            ))
                                        .toList()),
                                itemExtent: 60,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    repository.trackData != null
                        ? const StaticPLayer()
                        : Container(),
                  ]);
                });
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
