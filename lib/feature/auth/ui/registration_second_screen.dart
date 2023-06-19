import 'package:flutter/material.dart';
import 'package:sound_machines/utils/colors.dart';
import 'package:sound_machines/utils/fonts.dart';
import 'package:sound_machines/widgets/buttons/custom_elevated_button.dart';

import '../../../widgets/text_field/password_text_field.dart';

class RegisterSecondScreen extends StatefulWidget {
  const RegisterSecondScreen({Key? key}) : super(key: key);

  @override
  State<RegisterSecondScreen> createState() => _RegisterSecondScreenState();
}

class _RegisterSecondScreenState extends State<RegisterSecondScreen> {
  final _passwordFirstController = TextEditingController();
  final _passwordSecondController = TextEditingController();
  final isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Регестрация',
          style: AppTypography.font20fff,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05, 10, MediaQuery.of(context).size.width * 0.05, 10),
          child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  PasswordTextField(
                    controller: _passwordFirstController,
                    isError: isError,
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text(
                      'Подтвердить пароль',
                      style: AppTypography.font25fff,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  PasswordTextField(
                    controller: _passwordSecondController,
                    isError: isError,
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                  const SizedBox(height: 45,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomElevatedButton(
                          callback: () {
                            Navigator.pushNamed(context, 'фыва');
                          },
                          width: 175,
                          height: 50,
                          text: "Зарегестрировать",
                          color: isError ? AppColors.errorColorTextField : AppColors.colorTextField,
                          borderRadius: 20,
                          border: Border.all(color: Colors.transparent)),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
