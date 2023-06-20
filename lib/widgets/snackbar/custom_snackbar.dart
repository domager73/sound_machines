import 'package:flutter/material.dart';

import '../../utils/colors.dart';

abstract class CustomSnackBar {
  static void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          color: AppColors.snackBarBackgroundColor,
        ),
      ),
      action: SnackBarAction(
        label: 'Окей',
        onPressed: () {},
      ),
      backgroundColor: AppColors.snackBarTextColor,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}