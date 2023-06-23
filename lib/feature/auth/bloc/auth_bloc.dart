// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

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
    on<UsedEmailEvent>(_usedEmail);
    on<AuthLoadingEvent>(_onLoading);
    on<AuthSuccessEvent>(_onSuccess);
    on<AuthFailEvent>(_onFail);
  }

  _subscribe(AuthSubscribe e, emit) {
    _authRepository.authState.stream.listen((event) {
      if (event == AuthStatesEnum.success) add(AuthSuccessEvent());
      if (event == AuthStatesEnum.fail) add(AuthFailEvent());
      if (event == AuthStatesEnum.loading) add(AuthLoadingEvent());
      if (event == AuthStatesEnum.emailUsed) add(UsedEmailEvent());
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
    _authRepository.registerWithEmailAndPassword();
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

  _usedEmail (UsedEmailEvent event, emit) {
    emit(InvalidEmailState());
  }
}
