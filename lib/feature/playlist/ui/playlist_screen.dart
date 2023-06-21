import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';
import '../../../widgets/sliverAppBar/sliver_appBar.dart';
import '../../../widgets/treck/small_treck.dart';
import '../../player/bloc/player_bloc.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PlayerBloc>(context).add(InitialLoadEvent());
    final repository = RepositoryProvider.of<PlayerRepository>(context);
    return BlocBuilder<PlayerBloc, PlayerBlocState>(
      builder: (context, state) {
        if (state is TrackLoadedState) {
          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                AppBarWidget(
                  text: 'Супер плейлист',
                  imagePath: 'Assets/obl_pllist.webp',
                  isButtonPlay: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                StreamBuilder(
                  stream: repository.trackChanges,
                  initialData: repository.queue!,
                  builder: (context, snapshot) {
                    return SliverFixedExtentList(
                      delegate: SliverChildListDelegate(snapshot.data!
                          .map((e) => SmallTrekScreen(
                                track: e,
                              ))
                          .toList()),
                      itemExtent: 60,
                    );
                  }
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
