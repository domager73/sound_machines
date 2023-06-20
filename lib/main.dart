import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_machines/app_repository.dart';
import 'package:sound_machines/feature/auth/bloc/auth_bloc.dart';
import 'package:sound_machines/feature/auth/data/auth_repository.dart';
import 'package:sound_machines/feature/auth/ui/login_screen.dart';
import 'package:sound_machines/feature/auth/ui/registration_second_screen.dart';
import 'package:sound_machines/servise/auth_service.dart';
import 'package:sound_machines/feature/auth/ui/welcome_screen.dart';
import 'package:sound_machines/servise/custom_bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_machines/utils/colors.dart';

import 'bloc/app_bloc.dart';
import 'feature/auth/ui/registration_first_screen.dart';
import 'feature/player/ui/player_screen.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CustomBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyRepositoryProviders());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound machine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.ubuntu().fontFamily,
        canvasColor: AppColors.blackColor,
      ),
      color: const Color(0xff292B57),
      routes: {
        '/welcome_screen' : (context) => const WelcomeScreen(),
        '/login_screen' : (context) => const LoginScreen(),
        '/register_first_screen' : (context) => const RegisterFirstScreen(),
        '/register_second_screen' : (context) => const RegisterSecondScreen(),
      },
      home: const HomePage(),
    );
  }
}

class MyRepositoryProviders extends StatelessWidget {
  MyRepositoryProviders({Key? key}) : super(key: key);

  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider(
          create: (_) => AppRepository(authService: authService)..checkAuth()),
      RepositoryProvider(
          create: (_) => AuthRepository(authService: authService))
    ], child: const MyBlocProviders());
  }
}

class MyBlocProviders extends StatelessWidget {
  const MyBlocProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => AuthBloc(
            appRepository: RepositoryProvider.of<AppRepository>(context),
            authRepository: RepositoryProvider.of<AuthRepository>(context))
          ..add(AuthSubscribe()),
        lazy: false,
      ),
      BlocProvider(
        create: (_) => AppBloc(
          appRepository: RepositoryProvider.of<AppRepository>(context),
        )..add(AppSubscribe()),
        lazy: false,
      ),
    ], child: MyApp());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppAuthState) {
              return const PlayerScreen();
            } else {
              return const WelcomeScreen();
            }
          },
        ),
      ),
    );
  }
}