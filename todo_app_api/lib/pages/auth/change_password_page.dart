import 'package:flutter/material.dart';
import 'package:todo_app_api/components/button/td_elevated_button.dart';
import 'package:todo_app_api/components/snack_bar/td_snack_bar.dart';
import 'package:todo_app_api/components/snack_bar/top_snack_bar.dart';
import 'package:todo_app_api/components/text_field/td_text_field_password.dart';
import 'package:todo_app_api/gen/assets.gen.dart';
import 'package:todo_app_api/pages/auth/login_page.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/remote/auth_services.dart';
import 'package:todo_app_api/services/remote/body/change_password_body.dart';
import 'package:todo_app_api/utils/validator.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key, required this.email});

  final String email;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<bool?> changePassword() async {
    final body = ChangePasswordBody()
      ..password = _newPasswordController.text
      ..oldPassword = _currentPasswordController.text;

    return _authServices.changePassword(body).then((response) {
      if (response.isSuccess) {
        showTopSnackBar(
          context,
          const TDSnackBar.success(
              message: 'Change password successfully, login 😍'),
        );
        return true;
      }
    }).catchError((onError) {
      // bat loi ben ngoai
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
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0)
                .copyWith(top: MediaQuery.of(context).padding.top + 38.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('Change Password',
                      style: TextStyle(color: AppColor.red, fontSize: 24.0)),
                  const SizedBox(height: 38.0),
                  Image.asset(
                    Assets.images.todoIcon.path,
                    width: 90.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 46.0),
                  TdTextFieldPassword(
                    controller: _currentPasswordController,
                    textInputAction: TextInputAction.next,
                    hintText: 'Current Password',
                    validator: Validator.requiredValidator,
                  ),
                  const SizedBox(height: 18.0),
                  TdTextFieldPassword(
                    controller: _newPasswordController,
                    textInputAction: TextInputAction.next,
                    hintText: 'New Password',
                    validator: Validator.passwordValidator,
                  ),
                  const SizedBox(height: 18.0),
                  TdTextFieldPassword(
                    controller: _confirmPasswordController,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.done,
                    hintText: 'Confirm Password',
                    validator: Validator.confirmPasswordValidator(
                        _newPasswordController.text),
                  ),
                  const SizedBox(height: 92.0),
                  TdElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        changePassword().then((value) {
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
