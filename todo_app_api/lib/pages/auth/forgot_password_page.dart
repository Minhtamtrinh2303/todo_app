import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:todo_app_api/components/button/td_elevated_button.dart';
import 'package:todo_app_api/components/snack_bar/td_snack_bar.dart';
import 'package:todo_app_api/components/snack_bar/top_snack_bar.dart';
import 'package:todo_app_api/components/text_field/td_text_field.dart';
import 'package:todo_app_api/gen/assets.gen.dart';
import 'package:todo_app_api/pages/auth/create_new_password_page.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/remote/auth_services.dart';
import 'package:todo_app_api/utils/validator.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future<bool?> _otp() async {
    return _authServices.sendOtp(_emailController.text.trim()).then((value) {
      if (value.isSuccess) {
        showTopSnackBar(
          context,
          const TDSnackBar.success(
              message: 'Otp has been sent, check your email 😍'),
        );
        return true;
      }
    }).catchError((onError) {
      log('message $onError');
      showTopSnackBar(
        context,
        TDSnackBar.error(message: '$onError 😐'),
      );
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0)
                .copyWith(top: MediaQuery.of(context).padding.top + 38.0),
            child: Form(
              key: _formKey,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Forgot Password',
                      style: TextStyle(color: AppColor.red, fontSize: 24.0)),
                  const SizedBox(height: 2.0),
                  Text('Enter Your Email',
                      style: TextStyle(
                          color: AppColor.brown.withOpacity(0.8),
                          fontSize: 18.6)),
                  const SizedBox(height: 38.0),
                  Image.asset(
                    Assets.images.todoIcon.path,
                    width: 90.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 36.0),
                  TdTextField(
                    controller: _emailController,
                    textInputAction: TextInputAction.done,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email, color: AppColor.orange),
                    validator: Validator.emailValidator,
                  ),
                  const SizedBox(height: 68.0),
                  TdElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _otp().then((value) {
                          if (value == true) {
                            Route route = MaterialPageRoute(
                              builder: ((context) => CreateNewPasswordPage(
                                    email: _emailController.text.trim(),
                                  )),
                            );
                            Navigator.of(context).push(route);
                            // Utils.push(
                            //   context,
                            //   CreateNewPasswordPage(
                            //     email: _emailController.text.trim(),
                            //   ),
                            // );
                          }
                        });
                      }
                    },
                    text: 'Next',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
