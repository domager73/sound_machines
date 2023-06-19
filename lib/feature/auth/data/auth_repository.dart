import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sound_machines/utils/constants.dart';

import '../../../servise/auth_service.dart';

enum AuthStatesEnum { wait, loading, success, fail, emailUsed }

class AuthRepository {
  AuthRepository({required AuthService authService})
      : _authService = authService;

  final AuthService _authService;
  BehaviorSubject<AuthStatesEnum> authState =
      BehaviorSubject<AuthStatesEnum>.seeded(AuthStatesEnum.wait);

  void _authWith(Future method) async {
    authState.add(AuthStatesEnum.loading);
    try {
      await method;
      authState.add(AuthStatesEnum.success);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        authState.add(AuthStatesEnum.emailUsed);
        rethrow;
      } else {
        authState.add(AuthStatesEnum.fail);
      }
    } catch (e) {
      log(e.toString());
      authState.add(AuthStatesEnum.fail);
    }
  }

  void loginWithGoogle() => _authWith(_authService.signInWithGoogle());

  void loginWithEmailAndPassword(
          {required String email, required String password}) =>
      _authWith(_authService.sighInWithEmailAndPassword(email, password));

  String? _name;
  String? _email;
  String? _password;

  void registerWithEmailAndPassword() => _authWith(
      _authService.registerWithEmailAndPassword(_email!, _password!, _name!));

  void setName(String name) => _name = name;

  void setEmail(String email) => _email = email;

  void setPassword(String password) => _password = password;

  bool validateEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool validatePassword(String firstPassword, String secondPassword) {
    return firstPassword == secondPassword && firstPassword.length > 5;
  }

  bool validateName(String name) {
    return name.length > 2;
  }
}
