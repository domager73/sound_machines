import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/search_screen/bloc/playlists_cubit.dart';
import 'package:sound_machines/feature/search_screen/data/playlist_repository.dart';
import 'package:sound_machines/widgets/sliverAppBar/sliver_playlistContainer.dart';

import '../../../widgets/sliverAppBar/sliver_appBar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;

    final repository = RepositoryProvider.of<PlaylistRepository>(context);
    BlocProvider.of<PlaylistsCubit>(context).initialLoadPlaylists();
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
                expandedHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: width,
                  mainAxisExtent: width * 1.1,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 10.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return PlaylistWidget(
                        playlist: repository.playlists![index]);
                  },
                  childCount: repository.playlists!.length,
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