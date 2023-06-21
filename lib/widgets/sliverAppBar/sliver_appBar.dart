import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class AppBarWidget extends StatelessWidget {
  final String text;
  final String imagePath;
  final bool centerTitle;

  const AppBarWidget({
    Key? key,
    required this.text,
    required this.imagePath,
    this.centerTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 2
    return SliverAppBar(
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.greenButton,
      centerTitle: centerTitle,
      // 3
      expandedHeight: 200.0,
      // 4
      pinned: true,
      elevation: 0,
      // 5
      flexibleSpace: FlexibleSpaceBar(
        background: Image(image: AssetImage(imagePath),),
      ),
    );
  }
}
