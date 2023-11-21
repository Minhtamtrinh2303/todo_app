import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todo_app_api/gen/assets.gen.dart';
import 'package:todo_app_api/pages/auth/login_page.dart';
import 'package:todo_app_api/pages/main_page.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/local/shared_prefs.dart';
import 'package:todo_app_api/utils/utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  void _checkToken() {
    Timer(const Duration(milliseconds: 2600), () {
      final token = SharedPrefs.token;
      if (token != null && token.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.pushAndRemoveUtil(
              context, const MainPage(title: 'Todos', pageIndex: 0));
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.pushAndRemoveUtil(context, const LoginPage());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.images.todoIcon.path,
              width: 112.0,
              fit: BoxFit.cover,
            ),
            Shimmer.fromColors(
              baseColor: Colors.red,
              highlightColor: Colors.yellow,
              child: const Text(
                'Flutter Todos',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
