import 'package:flutter/material.dart';
import 'package:sound_machines/feature/auth/data/auth_repository.dart';
import 'package:sound_machines/utils/colors.dart';
import 'package:sound_machines/utils/dialogs.dart';
import 'package:sound_machines/utils/fonts.dart';
import 'package:sound_machines/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/snackbar/custom_snackbar.dart';
import '../../../widgets/text_field/password_text_field.dart';
import '../bloc/auth_bloc.dart';

class RegisterSecondScreen extends StatefulWidget {
  const RegisterSecondScreen({Key? key}) : super(key: key);

  @override
  State<RegisterSecondScreen> createState() => _RegisterSecondScreenState();
}

class _RegisterSecondScreenState extends State<RegisterSecondScreen> {
  final _passwordFirstController = TextEditingController();
  final _passwordSecondController = TextEditingController();
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    void checkPassword() {
      if (RepositoryProvider.of<AuthRepository>(context).validatePassword(
          _passwordFirstController.text, _passwordSecondController.text)) {
        RepositoryProvider.of<AuthRepository>(context)
            .setPassword(_passwordSecondController.text);
        BlocProvider.of<AuthBloc>(context).add(RegisterWithEmailEvent());
      } else {
        isError = true;
      }
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is InvalidEmailState) {
          Dialogs.hide(context);
          Navigator.pop(context);
          CustomSnackBar.showSnackBar(context, "Email уже искользуется");
        }
        if (state is AuthSuccessState) {
          Dialogs.hide(context);
          Navigator.pop(context);
          Navigator.pop(context);
        }
        if (state is AuthLoadingState) {
          Dialogs.showModal(context, const Center(child: CircularProgressIndicator()));
        }
        if (state is AuthFailState) {
          Dialogs.hide(context);
          CustomSnackBar.showSnackBar(context, "что-то пошло не так");
        }
      },
      child: Scaffold(
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
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                10,
                MediaQuery.of(context).size.width * 0.05,
                10),
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
                    const SizedBox(
                      height: 45,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomElevatedButton(
                            callback: () {
                              checkPassword();
                            },
                            width: 175,
                            height: 50,
                            text: "Зарегестрировать",
                            color: isError
                                ? AppColors.errorColorTextField
                                : AppColors.colorTextField,
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
