import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';
import 'package:sound_machines/utils/fonts.dart';
import 'package:sound_machines/widgets/sliverAppBar/sliver_playlistContainer.dart';

import '../../../widgets/sliverAppBar/sliver_appBar.dart';
import '../../../widgets/treck/small_treck.dart';
import '../bloc/playlists_cubit.dart';
import '../data/playlists_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;

    final repository = RepositoryProvider.of<PlaylistRepository>(context);
    final playerRepository = RepositoryProvider.of<PlayerRepository>(context);
    // BlocProvider.of<PlaylistsCubit>(context).initialLoadPlaylists();
    return BlocBuilder<PlaylistsCubit, PlaylistsState>(
        builder: (context, state) {
      if (state is PlaylistsSuccessState) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              AppBarWidget(
                text: 'Spotity',
                imagePath: 'Assets/image_not_found.jpg',
                isButtonPlay: true,
                isPlayList: false,
                expandedHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 10,
                  color: Colors.transparent,
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                child: const Text(
                  'Ваш выбор',
                  style: AppTypography.font32fff,
                ),
              )),
              SliverToBoxAdapter(
                child: Container(
                  height: 250.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: repository.playlists!.length,
                    itemBuilder: (context, index) {
                      return PlaylistWidget(
                          playlist: repository.playlists![index]);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                child: const Text(
                  'Плейлисты дня',
                  style: AppTypography.font32fff,
                ),
              )),
              SliverToBoxAdapter(
                child: Container(
                  height: 250.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: repository.playlists!.length,
                    itemBuilder: (context, index) {
                      return PlaylistWidget(
                          playlist: repository.playlists![index]);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                child: const Text(
                  'Плейлисты месяца',
                  style: AppTypography.font32fff,
                ),
              )),
              SliverToBoxAdapter(
                child: Container(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: repository.playlists!.length,
                    itemBuilder: (context, index) {
                      return PlaylistWidget(
                          playlist: repository.playlists![index]);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                child: const Text(
                  'Треки',
                  style: AppTypography.font32fff,
                ),
              )),
              StreamBuilder(
                stream: playerRepository.playlistChanges,
                builder: (context, snapshot) => playerRepository
                                .currentPlayListId ==
                            null &&
                        (playerRepository.queue ?? []).isNotEmpty
                    ? StreamBuilder(
                        stream: playerRepository.trackChanges,
                        builder: (context, snapshot) {
                          return SliverFixedExtentList(
                            delegate: SliverChildListDelegate(
                                RepositoryProvider.of<PlaylistRepository>(
                                        context)
                                    .mixedTracks!
                                    .map((e) => SmallTrekScreen(
                                          track: e,
                                          notInPlaylist: true,
                                        ))
                                    .toList()),
                            itemExtent: 60,
                          );
                        })
                    : SliverFixedExtentList(
                        delegate: SliverChildListDelegate(
                            RepositoryProvider.of<PlaylistRepository>(context)
                                .mixedTracks!
                                .map((e) => SmallTrekScreen(
                                      track: e,
                                      notInPlaylist: true,
                                    ))
                                .toList()),
                        itemExtent: 60,
                      ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
