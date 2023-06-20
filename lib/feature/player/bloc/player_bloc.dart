import 'dart:async';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sound_machines/utils/constants.dart';

import '../repository/player_repository.dart';

part 'player_event.dart';

part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerRepository playerRepository;

  PlayerBloc({required this.playerRepository}) : super(PlayerInitial()) {
    on<PlayerSubscribe>(_subscribe);
    on<InitialLoadEvent>(_initialLoad);
    on<PlayerLoadingEvent>(_onLoading);
    on<TrackLoadedEvent>(_onSuccess);
    on<TrackLoadFailEVent>(_onFail);
  }

  _subscribe(PlayerSubscribe e, emit) {
    playerRepository.trackDataLoadingState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) add(PlayerLoadingEvent());
      if (event == LoadingStateEnum.success) add(TrackLoadedEvent());
      if (event == LoadingStateEnum.fail) add(TrackLoadFailEVent());
    });
  }

  _initialLoad(InitialLoadEvent event, emit) => playerRepository.initialLoad();

  _onLoading(PlayerLoadingEvent event, emit) => emit(PlayerLoadingState());

  _onSuccess(TrackLoadedEvent event, emit) => emit(TrackLoadedState());

  _onFail(TrackLoadFailEVent event, emit) => emit(TrackLoadFailState);
}