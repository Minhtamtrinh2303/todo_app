import 'package:flutter/material.dart';
import 'package:todo_app_api/components/button/td_elevated_button.dart';
import 'package:todo_app_api/components/snack_bar/td_snack_bar.dart';
import 'package:todo_app_api/components/snack_bar/top_snack_bar.dart';
import 'package:todo_app_api/components/text_field/td_text_field.dart';
import 'package:todo_app_api/components/text_field/td_text_field_password.dart';
import 'package:todo_app_api/gen/assets.gen.dart';
import 'package:todo_app_api/pages/auth/forgot_password_page.dart';
import 'package:todo_app_api/pages/auth/register_page.dart';
import 'package:todo_app_api/pages/main_page.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/local/shared_prefs.dart';
import 'package:todo_app_api/services/remote/auth_services.dart';
import 'package:todo_app_api/services/remote/body/login_body.dart';
import 'package:todo_app_api/services/remote/code_error.dart';
import 'package:todo_app_api/utils/validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.email});

  final String? email;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;

  Future<bool?> _login() async {
    setState(() => isLoading = true);
    final body = LoginBody()
      ..email = _emailController.text.trim()
      ..password = _passwordController.text.trim();

    return _authServices.login(body).then((response) {
      if (response.isSuccess) {
        SharedPrefs.token = response.body?['token'] ?? '';
        setState(() => isLoading = false);
        return true;
      } else {
        showTopSnackBar(
          context,
          TDSnackBar.error(message: response.message?.toLang ?? '😐'),
        );
        setState(() => isLoading = false);
        return false;
      }
    }).catchError((onError) {
      showTopSnackBar(
        context,
        TDSnackBar.error(message: '$onError 😐'),
      );
      setState(() => isLoading = false);
      return false;
    });
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      _login().then((value) {
        if (value ?? false) {
          Route route = MaterialPageRoute(
              builder: (context) => const MainPage(title: 'Todos'));
          Navigator.of(context)
              .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email ?? '';
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
                  const Text('Welcome Back',
                      style: TextStyle(color: AppColor.red, fontSize: 24.0)),
                  const SizedBox(height: 2.0),
                  const Text('Login to your account',
                      style: TextStyle(color: AppColor.grey, fontSize: 18.0)),
                  const SizedBox(height: 32.0),
                  Image.asset(
                    Assets.images.todoIcon.path,
                    width: 90.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 36.0),
                  TdTextField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email, color: AppColor.orange),
                    validator: Validator.emailValidator,
                  ),
                  const SizedBox(height: 18.0),
                  TdTextFieldPassword(
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submitLogin(),
                    hintText: 'Password',
                    validator: Validator.passwordValidator,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        )),
                        child: const Text(
                          'Register',
                          style: TextStyle(color: AppColor.red, fontSize: 16.0),
                        ),
                      ),
                      const Text(
                        ' | ',
                        style:
                            TextStyle(color: AppColor.orange, fontSize: 16.0),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        )),
                        child: const Text(
                          'Forgot Password?',
                          style:
                              TextStyle(color: AppColor.brown, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 90.0),
                  TdElevatedButton(
                    onPressed: () => _submitLogin(),
                    text: 'Login',
                    isDisable: isLoading,
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
