import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/utils/fonts.dart';

import '../../../widgets/containers/playlist_container.dart';
import '../../../widgets/containers/small_treck.dart';
import '../../../widgets/slivers/sliver_appBar.dart';
import '../../player/repository/player_repository.dart';
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
    final repository = RepositoryProvider.of<PlaylistRepository>(context);
    final playerRepository = RepositoryProvider.of<PlayerRepository>(context);

    void setPlay(int index) async {
      if (PlaylistRepository.homeScreenMixedTracksId == playerRepository.currentPlayListId &&
          playerRepository.queue != null) {
        playerRepository.setTrack(playerRepository.queue![index]);
      } else {
        repository.currentPlaylist = PlaylistRepository.homeScreenMixedTracksId;
        playerRepository.setNewPlaylist(PlaylistRepository.homeScreenMixedTracksId, repository.mixedTracks!,
            index: index);
      }
    }

    return BlocBuilder<PlaylistsCubit, PlaylistsState>(
        builder: (context, state) {
      if (state is PlaylistsSuccessState) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              AppBarWidget(
                text: 'Spotify',
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
              const SliverToBoxAdapter(
                  child: Text(
                    'Ваш выбор',
                    style: AppTypography.font32fff,
                  )),
              SliverToBoxAdapter(
                child: SizedBox(
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
              const SliverToBoxAdapter(
                  child: Text(
                    'Плейлисты дня',
                    style: AppTypography.font32fff,
                  )),
              SliverToBoxAdapter(
                child: SizedBox(
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
              const SliverToBoxAdapter(
                  child: Text(
                    'Плейлисты месяца',
                    style: AppTypography.font32fff,
                  )),
              SliverToBoxAdapter(
                child: SizedBox(
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
              const SliverToBoxAdapter(
                  child: Text(
                    'Треки',
                    style: AppTypography.font32fff,
                  )),
              StreamBuilder(
                stream: playerRepository.playerStream,
                builder: (context, snapshot) =>  SliverFixedExtentList(
                  delegate: SliverChildListDelegate(
                      repository.getCurrentQueue(playingTrack: playerRepository.trackData, type: PlaylistRepository.homeScreenMixedTracksId)
                          .map((e) => SmallTrekScreen(
                        track: e,
                        onTap: setPlay,
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
