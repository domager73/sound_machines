import 'package:flutter/material.dart';
import 'package:sound_machines/utils/fonts.dart';

import '../../../utils/colors.dart';
import '../../../widgets/buttons/custom_elevated_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Image(
                    image: AssetImage('Assets/spotify_img.png'),
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text(
                      "Миллион треков. Бесплатно в Spotify.",
                      style: AppTypography.font32fff,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    callback: () {},
                    text: 'Зарегестрироваться',
                    styleText: AppTypography.font16000,
                    color: AppColors.greenButton,
                    border: const Border(),
                    borderRadius: 20,
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomElevatedButton(
                    callback: () {},
                    text: 'Войти через Google',
                    styleText: AppTypography.font16fff,
                    color: AppColors.blackColor,
                    border: Border.all(color: AppColors.borderGrey, width: 1.5),
                    borderRadius: 20,
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomElevatedButton(
                    callback: () {
                      Navigator.pushNamed(context, '/login_screen');
                    },
                    text: 'Войти',
                    styleText: AppTypography.font20fff,
                    color: AppColors.blackColor,
                    border: Border(),
                    borderRadius: 20,
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ))),
    );
  }
}
