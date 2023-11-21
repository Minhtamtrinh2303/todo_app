import 'dart:developer';
import 'package:todo_app_api/components/button/td_elevated_button.dart';
import 'package:todo_app_api/components/snack_bar/td_snack_bar.dart';
import 'package:todo_app_api/components/snack_bar/top_snack_bar.dart';
import 'package:todo_app_api/components/text_field/td_text_field_password.dart';
import 'package:todo_app_api/gen/assets.gen.dart';
import 'package:todo_app_api/pages/auth/login_page.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/remote/auth_services.dart';
import 'package:todo_app_api/services/remote/body/new_password_body.dart';
import 'package:todo_app_api/utils/validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CreateNewPasswordPage extends StatefulWidget {
  const CreateNewPasswordPage({super.key, required this.email});

  final String email;

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final _verificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _otp() {
    _authServices.sendOtp(widget.email).then((value) {
      if (value.isSuccess) {
        showTopSnackBar(
          context,
          const TDSnackBar.success(
              message: 'Otp has been sent, check your email 😍'),
        );
      }
    }).catchError((onError) {
      log('message $onError');
      showTopSnackBar(
        context,
        TDSnackBar.error(message: '$onError 😐'),
      );
    });
  }

  Future<bool?> _newPassword() async {
    final body = NewPasswordBody()
      ..email = widget.email
      ..password = _passwordController.text
      ..code = _verificationCodeController.text;

    return _authServices.postForgotPassword(body).then((value) {
      if (value.isSuccess) {
        showTopSnackBar(
          context,
          const TDSnackBar.success(message: 'New password is created 😍'),
        );
        return true;
      }
    }).catchError((onError) {
      // bat loi ben ngoai
      log('message $onError');
      showTopSnackBar(
        context,
        TDSnackBar.error(message: '$onError 😐'),
      );
      return false;
    });
    // return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0)
                .copyWith(top: MediaQuery.of(context).padding.top + 38.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('Forgot Password',
                      style: TextStyle(color: AppColor.red, fontSize: 24.0)),
                  const SizedBox(height: 2.0),
                  Text('Create New Password',
                      style: TextStyle(
                          color: AppColor.brown.withOpacity(0.8),
                          fontSize: 18.6)),
                  const SizedBox(height: 38.0),
                  Image.asset(
                    Assets.images.todoIcon.path,
                    width: 90.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 46.0),
                  PinCodeTextField(
                    controller: _verificationCodeController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    appContext: context,
                    textStyle: const TextStyle(color: AppColor.red),
                    length: 4,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8.6),
                      fieldHeight: 46.0,
                      fieldWidth: 40.0,
                      activeFillColor: AppColor.red,
                      inactiveColor: AppColor.orange,
                      activeColor: AppColor.red,
                      selectedColor: AppColor.orange,
                    ),
                    scrollPadding: EdgeInsets.zero,
                    onChanged: (_) {},
                    onCompleted: (value) {
                      _verificationCodeController.text = value;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 6.0),
                  RichText(
                    text: TextSpan(
                      text: 'You didn\'t receive the pin code? ',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: AppColor.grey,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Resend',
                          style:
                              TextStyle(color: AppColor.red.withOpacity(0.86)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _otp(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TdTextFieldPassword(
                    controller: _passwordController,
                    textInputAction: TextInputAction.next,
                    hintText: 'Password',
                    validator: Validator.passwordValidator,
                  ),
                  const SizedBox(height: 18.0),
                  TdTextFieldPassword(
                    controller: _confirmPasswordController,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.done,
                    hintText: 'Confirm Password',
                    validator: Validator.confirmPasswordValidator(
                        _passwordController.text),
                  ),
                  const SizedBox(height: 72.0),
                  TdElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _newPassword().then((value) {
                          if (value == true) {
                            Route route = MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage(email: widget.email));
                            Navigator.of(context).pushAndRemoveUntil(
                                route, (Route<dynamic> route) => false);
                            // Utils.pushAndRemoveUtil(
                            //     context, LoginPage(email: widget.email));
                          }
                        });
                      }
                    },
                    text: 'Done',
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
