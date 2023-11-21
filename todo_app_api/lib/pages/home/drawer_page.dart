import 'package:flutter/material.dart';
import 'package:todo_app_api/components/dialog/td_dialog.dart';
import 'package:todo_app_api/gen/assets.gen.dart';
import 'package:todo_app_api/models/app_user_model.dart';
import 'package:todo_app_api/pages/auth/change_password_page.dart';
import 'package:todo_app_api/pages/auth/login_page.dart';
import 'package:todo_app_api/pages/profile/profile_page.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/local/shared_prefs.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key, this.pageIndex, required this.appUser});

  final AppUserModel appUser;
  final int? pageIndex;

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    const iconSize = 18.0;
    const iconColor = AppColor.orange;
    const spacer = 6.0;
    const textStyle = TextStyle(color: AppColor.brown, fontSize: 16.0);

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Welcome',
              style: TextStyle(color: AppColor.red, fontSize: 20.0)),
          Text(
            widget.appUser.name ?? '-:-',
            style: const TextStyle(
                color: AppColor.brown,
                fontSize: 16.8,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 18.0),
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ProfilePage(pageIndex: widget.pageIndex ?? 0),
            )),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: const Row(
              children: [
                Icon(Icons.person, size: iconSize, color: iconColor),
                SizedBox(width: spacer),
                Text('My Profile', style: textStyle),
              ],
            ),
          ),
          const SizedBox(height: 18.0),
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ChangePasswordPage(email: widget.appUser.email ?? ''),
            )),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: const Row(
              children: [
                Icon(Icons.lock_outline, size: iconSize, color: iconColor),
                SizedBox(width: spacer),
                Text('Change Password', style: textStyle),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16.0, right: 20.0),
            height: 1.2,
            color: AppColor.grey,
          ),
          const Spacer(flex: 1),
          Row(
            children: [
              const SizedBox(width: 12.0),
              Expanded(child: Image.asset(Assets.images.todoIconTwo.path)),
            ],
          ),
          const Spacer(flex: 2),
          InkWell(
            onTap: () async {
              bool? status = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return TDDialog(
                      title: 'Do you want to logout?',
                      subText: 'You will be logged out of the application',
                      icon: Icons.logout,
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    );
                  });
              if (status ?? false) {
                SharedPrefs.removeSeason();
                Route route = MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                );
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushAndRemoveUntil(
                      route, (Route<dynamic> route) => false);
                });
              }
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: const Row(
              children: [
                Icon(Icons.logout, size: iconSize, color: iconColor),
                SizedBox(width: spacer),
                Text('Logout', style: textStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
