import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_api/components/button/td_elevated_button.dart';
import 'package:todo_app_api/components/snack_bar/td_snack_bar.dart';
import 'package:todo_app_api/components/snack_bar/top_snack_bar.dart';
import 'package:todo_app_api/components/text_field/td_text_field.dart';
import 'package:todo_app_api/components/text_field/td_text_field_password.dart';
import 'package:todo_app_api/gen/assets.gen.dart';
import 'package:todo_app_api/pages/auth/verification_code_page.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/remote/account_services.dart';
import 'package:todo_app_api/services/remote/auth_services.dart';
import 'package:todo_app_api/services/remote/body/register_body.dart';
import 'package:todo_app_api/utils/validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? avatar;
  File? fileAvatar;
  bool isLoadingAvatar = false;

  bool isLoad = false;

  Future<void> _pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result == null) return;
    fileAvatar = File(result.files.single.path!);
    isLoadingAvatar = true;
    setState(() {});
    avatar = await uploadFile();
    Future.delayed(const Duration(milliseconds: 2600));
    isLoadingAvatar = false;
    setState(() {});
  }

  Future<String?> uploadFile() async {
    if (fileAvatar == null) return null;
    return AccountServices().uploadFile(fileAvatar!).then((response) {
      if (response.isSuccess) {
        setState(() => isLoad = false);
        return response.body?.file;
      }
    }).catchError((onError) {
      setState(() => isLoad = false);
      log('$onError');
      return null;
    });
  }

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
                children: [
                  const Text('Register',
                      style: TextStyle(color: AppColor.red, fontSize: 24.0)),
                  const SizedBox(height: 2.0),
                  Text('Create your new account',
                      style: TextStyle(
                          color: AppColor.brown.withOpacity(0.8),
                          fontSize: 18.0)),
                  const SizedBox(height: 32.0),
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: Stack(
                      children: [
                        isLoadingAvatar
                            ? CircleAvatar(
                                radius: 34.6,
                                backgroundColor: Colors.orange.shade200,
                                child: const SizedBox.square(
                                  dimension: 36.0,
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                    strokeWidth: 2.6,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 34.6,
                                backgroundImage: fileAvatar == null
                                    // ? Assets.images.defaultAvatar.provider()
                                    ? AssetImage(
                                            Assets.images.defaultAvatar.path)
                                        as ImageProvider
                                    : FileImage(
                                        File(fileAvatar?.path ?? ''),
                                      ),
                              ),
                        Positioned(
                          right: 0.0,
                          bottom: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.pink)),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 14.6,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 42.0),
                  TdTextField(
                    controller: _fullNameController,
                    textInputAction: TextInputAction.next,
                    hintText: "Full Name",
                    prefixIcon:
                        const Icon(Icons.person, color: AppColor.orange),
                    validator: Validator.requiredValidator,
                  ),
                  const SizedBox(height: 18.0),
                  TdTextField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email, color: AppColor.orange),
                    validator: Validator.emailValidator,
                  ),
                  const SizedBox(height: 18.0),
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
                  const SizedBox(height: 86.0),
                  TdElevatedButton(
                    isDisable: isLoad,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _otp().then((value) {
                          if (value == true) {
                            Route route = MaterialPageRoute(
                              builder: (context) => VerificationCodePage(
                                registerBody: RegisterBody()
                                  ..name = _fullNameController.text.trim()
                                  ..email = _emailController.text.trim()
                                  ..password = _passwordController.text
                                  ..avatar = avatar,
                              ),
                            );
                            Navigator.of(context).push(route);
                            // Utils.push(
                            //   context,
                            //   VerificationCodePage(
                            //     registerBody: RegisterBody()
                            //       ..name = _fullNameController.text.trim()
                            //       ..email = _emailController.text.trim()
                            //       ..password = _passwordController.text,
                            //   ),
                            // );
                          }
                        });
                      }
                    },
                    text: 'Sign up',
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
