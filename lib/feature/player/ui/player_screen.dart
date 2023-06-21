import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';
import 'package:sound_machines/widgets/players/player.dart';

import '../../../bloc/app_bloc.dart';
import '../bloc/player_bloc.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PlayerBloc>(context).add(InitialLoadEvent());
    final repository = RepositoryProvider.of<PlayerRepository>(context);
    return BlocBuilder<PlayerBloc, PlayerBlocState>(
      builder: (context, state) {
        if (state is TrackLoadedState) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.amber,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {

                      BlocProvider.of<AppBloc>(context).add(LogoutEvent());
                    },
                    child: const Text(
                      'Выйти',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            body: CustomPlayer(name: repository.trackData!.name, imageUrl: repository.trackData!.imageUrl)
          );
        }
        else  {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}
