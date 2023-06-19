import 'package:flutter/material.dart';
import 'package:sound_machines/utils/colors.dart';

import '../../utils/fonts.dart';

class PasswordTextField extends StatefulWidget {
  final double width;
  final double height;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final bool isError;
  final double borderRadius;

  const PasswordTextField(
      {Key? key,
      required this.controller,
      required this.isError,
      this.width = 290,
      this.height = 50,
      this.keyBoardType = TextInputType.text,
      this.borderRadius = 5})
      : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isVisible = false;

  void showHide() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          color: widget.isError
              ? AppColors.errorColorTextField
              : AppColors.colorTextField),
      child: TextFormField(
        obscureText: isVisible,
        keyboardType: widget.keyBoardType,
        style:
            widget.isError ? AppTypography.font16f00 : AppTypography.font16fff,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: showHide,
            child: isVisible
                ? const Icon(Icons.remove_red_eye_outlined, color: Colors.white,)
                : const Icon(Icons.remove_red_eye, color: Colors.white,),
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
        controller: widget.controller,
      ),
    );
  }
}
