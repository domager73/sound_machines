import 'package:flutter/material.dart';
import 'package:sound_machines/utils/fonts.dart';

import '../../utils/colors.dart';

class AppBarWidget extends StatelessWidget {
  final String text;
  final String imagePath;

  const AppBarWidget({
    Key? key,
    required this.text,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        text,
        style: AppTypography.font32fff,
      ),
      backgroundColor: Colors.transparent,
      centerTitle: false,
      expandedHeight: 350.0,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          padding: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              repeat: ImageRepeat.repeat
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      InkWell(
                        child: const Icon(
                          Icons.play_circle,
                          size: 100,
                          color: AppColors.playColor,
                        ),
                        onTap: () {},
                      ),
                      Text('пауза', style: AppTypography.font16fff,),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
