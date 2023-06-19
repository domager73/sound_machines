import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_machines/utils/constants.dart';

import '../../../servise/auth_service.dart';

class AuthRepository {
  AuthRepository({required AuthService authService})
      : _authService = authService;

  final AuthService _authService;
  BehaviorSubject<LoadingStateEnum> authState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  void _authWith(Future method) async {
    authState.add(LoadingStateEnum.loading);
    try {
      await method;
      authState.add(LoadingStateEnum.success);
    } catch (e) {
      authState.add(LoadingStateEnum.fail);
    }
  }

  void loginWithGoogle() => _authWith(_authService.signInWithGoogle());

  void registerWithEmailAndPassword(
          {required String email,
          required String password,
          required String name}) =>
      _authWith(
          _authService.registerWithEmailAndPassword(email, password, name));

  void loginWithEmailAndPassword(
          {required String email, required String password}) =>
      _authWith(_authService.sighInWithEmailAndPassword(email, password));
}
