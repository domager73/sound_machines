import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/fonts.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({Key? key,
    required this.callback,
    required this.text,
    required this.border,
    this.styleText = AppTypography.font16fff,
    this.width = 290,
    this.height = 50,
    this.color = AppColors.blackColor,
    this.padding = const EdgeInsets.all(10),
    this.borderRadius = 5})
      : super(key: key);

  final VoidCallback callback;
  final String text;
  final double width;
  final double height;
  final TextStyle styleText;
  final Color color;
  final Border border;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        border: border,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        ),
        onPressed: callback,
        child: Text(
          text,
          style: styleText,
        ),
      ),
    );
  }
}
