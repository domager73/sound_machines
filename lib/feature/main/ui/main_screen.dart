import 'package:flutter/material.dart';
import 'package:sound_machines/feature/player/repository/player_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/widgets/players/static_player.dart';

import '../../home_screen/ui/home_screen.dart';
import '../../search/ui/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SearchScreen(),
  ];

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    void onSelectTab(int index) {
      if (_selectedTab == index) return;
      setState(() {
        _selectedTab = index;
      });
    }
    final repository = RepositoryProvider.of<PlayerRepository>(context);
    return WillPopScope(
      child: Scaffold(
        body: StreamBuilder(
                stream: repository.playerStream,
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      _widgetOptions[_selectedTab],
                      repository.trackData != null
                          ? const StaticPLayer()
                          : Container(),
                    ],
                  );
                }
        ),
        bottomNavigationBar: ClipRRect(
          child: BottomNavigationBar(
            iconSize: 30,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedTab,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.add_home_outlined, color: Colors.white),
                activeIcon: Icon(Icons.add_home, color: Colors.white,),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.white,),
                activeIcon: Icon(Icons.search, color: Colors.white),
                label: '',
              ),
            ],
            onTap: onSelectTab,
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}