import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/widgets/players/player.dart';

import '../../../bloc/app_bloc.dart';
import '../bloc/player_bloc.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
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
            body: const CustomPlayer()
          );
        }
        else  {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}
