import 'dart:developer';
import 'package:todo_app_api/components/button/td_elevated_button.dart';
import 'package:todo_app_api/components/snack_bar/td_snack_bar.dart';
import 'package:todo_app_api/components/snack_bar/top_snack_bar.dart';
import 'package:todo_app_api/gen/assets.gen.dart';
import 'package:todo_app_api/pages/auth/login_page.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/remote/auth_services.dart';
import 'package:todo_app_api/services/remote/body/register_body.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({
    super.key,
    required this.registerBody,
  });

  final RegisterBody registerBody;

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final _verificationCodeController = TextEditingController();

  void _otp() {
    _authServices.sendOtp(widget.registerBody.email ?? '').then((value) {
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

  Future<bool?> _register() async {
    // final body = widget.registerBody..code = _verificationCodeController.text;
    RegisterBody body = RegisterBody()
      ..name = widget.registerBody.name
      ..email = widget.registerBody.email
      ..password = widget.registerBody.password
      ..code = _verificationCodeController.text
      ..avatar = widget.registerBody.avatar;

    return _authServices.register(body).then((value) {
      log('object email ${value.body?.email}');
      if (value.isSuccess) {
        showTopSnackBar(
          context,
          const TDSnackBar.success(message: 'Register successfully, login 😍'),
        );
        return true;
      } else {
        showTopSnackBar(
          context,
          const TDSnackBar.error(message: 'Invalid OTP, please resend 😐'),
          // TDSnackBar.error(message: '${value.message}, register again 😐'),
        );
        return false;
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
                  const Text('Register',
                      style: TextStyle(color: AppColor.red, fontSize: 24.0)),
                  const SizedBox(height: 2.0),
                  Text('Enter Verification Code',
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
                    cursorColor: AppColor.orange,
                    cursorHeight: 16.0,
                    cursorWidth: 2.0,
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
                  const SizedBox(height: 120.0),
                  TdElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _register().then((value) {
                          if (value == true) {
                            Route route = MaterialPageRoute(
                                builder: (context) => LoginPage(
                                    email: widget.registerBody.email));
                            Navigator.of(context).pushAndRemoveUntil(
                                route, (Route<dynamic> route) => false);
                            // Utils.pushAndRemoveUtil(context,
                            //     LoginPage(email: widget.registerBody.email));
                          } else {
                            _verificationCodeController.clear();
                            setState(() {});
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
