import 'package:rxdart/rxdart.dart';
import 'package:sound_machines/servise/auth_service.dart';
import 'package:sound_machines/utils/constants.dart';

class AppRepository {
  AppRepository({required AuthService authService}) : _authService = authService;

  final AuthService _authService;
  BehaviorSubject<AppAuthStateEnum> appState = BehaviorSubject<AppAuthStateEnum>.seeded(AppAuthStateEnum.wait);

  void checkAuth() async {
    try {
      final user = await _authService.checkLogin();
      appState.add(user != null ? AppAuthStateEnum.auth : AppAuthStateEnum.unauth);
    } catch (e) {
      setUnAuth();
    }
  }

  void setAuth () => appState.add(AppAuthStateEnum.auth);

  void setUnAuth () => appState.add(AppAuthStateEnum.unauth);

  void logout () {
    _authService.logout();
    setUnAuth();
  }
}