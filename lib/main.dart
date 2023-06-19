import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sound_machines/servise/custom_bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CustomBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyRepositoryProviders());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Wave',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.ubuntu().fontFamily,
        canvasColor: const Color(0xff292B57),
      ),
      color: const Color(0xff292B57),
      routes: {

      },
      home: const HomePage(),
    );
  }
}

class MyRepositoryProviders extends StatelessWidget {
  MyRepositoryProviders({Key? key}) : super(key: key);
  final firebaseAuth = FirebaseAuthService();
  final apiService = ApiService(firestore: FirebaseFirestore.instance);
  final chatCore = FirebaseChatCore.instance;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider(
          create: (_) => AppRepository(firebaseAuthService: firebaseAuth, chatCore: chatCore)),
      RepositoryProvider(
          create: (_) => ProfileRepository(apiService: apiService)),
      RepositoryProvider(create: (_) => NewsRepository(apiService: apiService)),
      RepositoryProvider(create: (_) => ChatRepository()),
      RepositoryProvider(create: (_) => NeuronsRepository(apiService: apiService)),
      RepositoryProvider(create: (_) => UserChatsRepository()),
    ], child: const MyBlocProviders());
  }
}

class MyBlocProviders extends StatelessWidget {
  const MyBlocProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
        ], child: const MyApp());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          log(state.toString());
          if (state is AppAuthState) return const MainScreen();
          if (state is AppUnAuthState) {
            return Container(
              child: Text(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}