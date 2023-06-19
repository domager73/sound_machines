import 'package:flutter/material.dart';
import 'package:sound_machines/utils/colors.dart';
import 'package:sound_machines/utils/dialogs.dart';
import 'package:sound_machines/utils/fonts.dart';
import 'package:sound_machines/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/text_field/custom_text_field.dart';
import '../../../widgets/text_field/password_text_field.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final isError = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccessState) {
      Dialogs.hide(context);
      Navigator.pop(context);
    }
    if (state is AuthLoadingState) {
      Dialogs.showModal(context, const Center(child: CircularProgressIndicator()));
    }

    if (state is AuthFailState) {
      Dialogs.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Проблемс')));
    }
  },
  child: Scaffold(
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
                      'Пароль',
                      style: AppTypography.font25fff,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  PasswordTextField(
                    controller: _passwordController,
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
                            BlocProvider.of<AuthBloc>(context).add(AuthWithEmailEvent(email: _emailController.text, password: _passwordController.text));
                          },
                          width: 100,
                          height: 50,
                          text: "Вход",
                          color: isError ? AppColors.errorColorTextField : AppColors.colorTextField,
                          borderRadius: 20,
                          border: Border.all(color: Colors.transparent)),
                    ],
                  )
                ],
              )),
        ),
      ),
    ),
);
  }
}
