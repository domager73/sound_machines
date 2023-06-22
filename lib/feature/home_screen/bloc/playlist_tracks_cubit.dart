import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sound_machines/utils/constants.dart';

import '../data/playlists_repository.dart';

part 'playlist_tracks_state.dart';

class PlaylistTracksCubit extends Cubit<PlaylistTracksState> {
  PlaylistRepository playlistRepository;

  PlaylistTracksCubit({required this.playlistRepository}) : super(PlaylistTracksInitial()) {
    playlistRepository.tracksLoadingState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(PlaylistTracksLoadingState());
      if (event == LoadingStateEnum.success) emit(PlaylistTracksSuccessState());
      if (event == LoadingStateEnum.fail) emit(PlaylistTrackFailState());
    });
  }


}
