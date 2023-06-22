import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sound_machines/utils/constants.dart';

import '../data/playlists_repository.dart';

part 'playlists_state.dart';

class PlaylistsCubit extends Cubit<PlaylistsState> {
  PlaylistRepository playlistRepository;

  PlaylistsCubit({required this.playlistRepository}) : super(PlaylistsInitial()) {
    playlistRepository.playlistsLoadingState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(PlaylistsLoadingState());
      if (event == LoadingStateEnum.success) emit(PlaylistsSuccessState());
      if (event == LoadingStateEnum.fail) emit(PlaylistFailState());
    });
  }

  initialLoadPlaylists() {
    playlistRepository.loadPlaylists();
  }
}
