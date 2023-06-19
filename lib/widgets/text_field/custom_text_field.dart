import 'package:flutter/material.dart';
import 'package:sound_machines/utils/colors.dart';

import '../../utils/fonts.dart';

class CustomTextField extends StatelessWidget {
  final double width;
  final double height;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final bool isError;
  final double borderRadius;

  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.isError,
      this.width = 290,
      this.height = 50,
      this.keyBoardType = TextInputType.text,
      this.borderRadius = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: isError ? AppColors.errorColorTextField : AppColors.colorTextField),
      child: TextFormField(
        //onSaved: (_) {FocusScope.of(context).requestFocus(FocusNode());},
        keyboardType: keyBoardType,
        style: isError ? AppTypography.font16f00 : AppTypography.font16fff,
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
