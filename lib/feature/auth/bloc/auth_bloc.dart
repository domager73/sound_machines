import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sound_machines/utils/constants.dart';

import '../../../app_repository.dart';
import '../data/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppRepository _appRepository;
  final AuthRepository _authRepository;

  AuthBloc(
      {required AppRepository appRepository,
      required AuthRepository authRepository})
      : _appRepository = appRepository,
        _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthSubscribe>(_subscribe);
    on<AuthWithGoogleEvent>(_onGoogle);
    on<AuthWithEmailEvent>(_onLoginWithEmail);
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);

    on<AuthLoadingEvent>(_onLoading);
    on<AuthSuccessEvent>(_onSuccess);
    on<AuthFailEvent>(_onFail);
  }

  _subscribe(AuthSubscribe e, emit) {
    _authRepository.authState.stream.listen((event) {
      if (event == LoadingStateEnum.success) add(AuthSuccessEvent());
      if (event == LoadingStateEnum.fail) add(AuthFailEvent());
      if (event == LoadingStateEnum.loading) add(AuthLoadingEvent());
    });
  }

  _onGoogle(AuthWithGoogleEvent event, emit) {
    _authRepository.loginWithGoogle();
  }

  _onLoginWithEmail(AuthWithEmailEvent event, emit) {
    _authRepository.loginWithEmailAndPassword(
        email: event.email, password: event.password);
  }

  _onRegisterWithEmail(RegisterWithEmailEvent event, emit) {
    _authRepository.registerWithEmailAndPassword(
        email: event.email, password: event.password, name: event.name);
  }

  _onLoading(AuthLoadingEvent event, emit) => emit(AuthLoadingState());

  _onSuccess(AuthSuccessEvent event, emit) {
    emit(AuthSuccessState());
    _appRepository.setAuth();
  }

  _onFail(AuthFailEvent event, emit) {
    emit(AuthFailState());
    _appRepository.setUnAuth();
  }
}
