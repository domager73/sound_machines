import 'package:flutter/material.dart';
import 'package:sound_machines/utils/colors.dart';
import 'package:sound_machines/utils/fonts.dart';
import 'package:sound_machines/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/text_field/custom_text_field.dart';
import '../data/auth_repository.dart';

class RegisterFirstScreen extends StatefulWidget {
  const RegisterFirstScreen({Key? key}) : super(key: key);

  @override
  State<RegisterFirstScreen> createState() => _RegisterFirstScreenState();
}

class _RegisterFirstScreenState extends State<RegisterFirstScreen> {
  final _emailController = TextEditingController();
  final _namedController = TextEditingController();
  bool isErrorEmail = false;
  bool isErrorName = false;

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<AuthRepository>(context);

    void checkvalidField() {
      if (repository.validateEmail(_emailController.text) &&
          repository.validateName(_namedController.text)) {
        repository.setName(_namedController.text);
        repository.setEmail(_emailController.text);
        Navigator.pushNamed(context, '/register_second_screen');
      }
      if(!repository.validateEmail(_emailController.text)){
        isErrorEmail = true;
      }
      if(!repository.validateName(_namedController.text)){
        isErrorName = true;
      }
      setState(() {});
    }

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
                      'Электронная почта пользователя',
                      style: AppTypography.font25fff,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    isError: isErrorEmail,
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text(
                      'Никнейм',
                      style: AppTypography.font25fff,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    controller: _namedController,
                    isError: isErrorName,
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                  const SizedBox(height: 45,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomElevatedButton(
                          callback: () {
                            checkvalidField();
                          },
                          width: 135,
                          height: 50,
                          text: "Продолжить",
                          color: isErrorEmail || isErrorName ? AppColors.errorColorTextField : AppColors.colorTextField,
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
