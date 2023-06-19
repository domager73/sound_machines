import 'package:flutter/material.dart';
import 'package:sound_machines/utils/colors.dart';
import 'package:sound_machines/utils/fonts.dart';
import 'package:sound_machines/widgets/buttons/custom_elevated_button.dart';

import '../../../widgets/text_field/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Вход',
          style: AppTypography.font20fff,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text(
                      'Электронная почта пользователя',
                      style: AppTypography.font25fff,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    isError: false,
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text(
                      'Пароль',
                      style: AppTypography.font25fff,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    isError: true,
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                  CustomElevatedButton(
                      callback: () {},
                      width: 100,
                      height: 50,
                      text: "Вход",
                      color: AppColors.borderGrey,
                      border: Border.all(color: Colors.transparent))
                ],
              )),
        ),
      ),
    );
  }
}
