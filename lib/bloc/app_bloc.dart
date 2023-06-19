import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sound_machines/utils/constants.dart';

import '../app_repository.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppRepository _appRepository;

  AppBloc({required AppRepository appRepository})
      : _appRepository = appRepository,
        super(AppInitial()) {
    on<AppSubscribe>(_subscribe);
    on<AppAuthEvent>(_onAuth);
    on<AppUnAuthEvent>(_onUnAuth);
  }

  _subscribe(AppSubscribe e, emit) {
    _appRepository.appState.stream.listen((event) {
      if (event == AppAuthStateEnum.auth) add(AppAuthEvent());
      if (event == AppAuthStateEnum.unauth) add(AppUnAuthEvent());
    });
  }

  _onAuth(AppAuthEvent event, emit) => emit(AppAuthState());

  _onUnAuth(AppUnAuthEvent event, emit) => emit(AppUnAuthState());
}
