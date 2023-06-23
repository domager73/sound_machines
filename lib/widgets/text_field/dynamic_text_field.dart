import 'package:flutter/material.dart';

import '../../utils/fonts.dart';

class DynamicTextField extends StatelessWidget{
  final double width;
  final double height;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final double borderRadius;
  final ValueChanged<String>? changed;
  final Color color;

  const DynamicTextField({
    Key? key,
    required this.controller,
    this.width = 290,
    this.height = 50,
    this.keyBoardType = TextInputType.text,
    this.borderRadius = 5,
    required this.changed,
    required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: color),
      child: TextFormField(
        onChanged: changed,
        keyboardType: keyBoardType,
        style: AppTypography.font16fff,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
        controller: controller,
      ),
    );
  }
}
