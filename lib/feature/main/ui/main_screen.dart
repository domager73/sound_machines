import 'package:flutter/material.dart';
import 'package:sound_machines/feature/player/ui/player_screen.dart';
import 'package:sound_machines/utils/fonts.dart';

import '../../../utils/colors.dart';
import '../../playlist.dart/ui/playlist_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _widgetOptions = <Widget>[
    const PlayListScreen(),
    const Text('asdfasdf')
  ];

  int _selectedTab = 0;

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          children: [
            _widgetOptions[_selectedTab],
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.playerBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Row(
                          children: [
                            const Image(
                              image: AssetImage('Assets/image_not_found.jpg'),
                              height: 50,
                              width: 50,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width - 160,
                              child: const Text(
                                'name',
                                style: AppTypography.font20fff,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(_createRoute());
                        },
                      ),
                      const InkWell(
                        child: Icon(
                          Icons.heart_broken_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const InkWell(
                        child: Icon(
                            Icons.play_arrow, color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const PlayerScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
