import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/utils/fonts.dart';
import 'package:sound_machines/widgets/sliverAppBar/sliver_playlistContainer.dart';

import '../../../widgets/sliverAppBar/sliver_appBar.dart';
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
                isButtonPlay: false,
                expandedHeight: MediaQuery.of(context).size.height * 0.2,
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
