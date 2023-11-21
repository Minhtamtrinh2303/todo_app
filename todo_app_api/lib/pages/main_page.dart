import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:todo_app_api/components/td_app_bar.dart';
import 'package:todo_app_api/components/td_zoom_drawer.dart';
import 'package:todo_app_api/constants/app_constant.dart';
import 'package:todo_app_api/models/app_user_model.dart';
import 'package:todo_app_api/pages/home/completed_page.dart';
import 'package:todo_app_api/pages/home/deleted_page.dart';
import 'package:todo_app_api/pages/home/drawer_page.dart';
import 'package:todo_app_api/pages/home/home_page.dart';
import 'package:todo_app_api/pages/home/uncompleted_page.dart';
import 'package:todo_app_api/pages/profile/profile_page.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/remote/account_services.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    required this.title,
    this.pageIndex,
  });

  final String title;
  final int? pageIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final zoomDrawerController = ZoomDrawerController();
  late int selectedIndex;
  AppUserModel appUser = AppUserModel();

  List pages = [
    const HomePage(),
    const CompletedPage(),
    const UncompletedPage(),
    const DeletedPage(),
  ];

  void getProfile() {
    AccountServices().getProfile().then((response) {
      if (response.isSuccess) {
        setState(() {
          appUser = response.body ?? AppUserModel();
        });
      }
    }).catchError((onError) {
      log(onError);
    });
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.pageIndex ?? 0;
    getProfile();
  }

  toggleDrawer() {
    zoomDrawerController.toggle?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: TdAppBar(
          leftPressed: toggleDrawer,
          rightPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfilePage(pageIndex: widget.pageIndex ?? 0),
          )),
          title: widget.title,
          avatar: AppConstant.baseImage(appUser.avatar ?? ''),
        ),
        body: TdZoomDrawer(
          controller: zoomDrawerController,
          menuScreen: DrawerPage(pageIndex: selectedIndex, appUser: appUser),
          screen: pages[selectedIndex],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return AnimatedContainer(
      height: 52.0,
      duration: const Duration(milliseconds: 2000),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: _navigationItem(0),
          ),
          Expanded(
            child: _navigationItem(1),
          ),
          Expanded(
            child: _navigationItem(2),
          ),
          Expanded(
            child: _navigationItem(3),
          ),
        ],
      ),
    );
  }

  Widget _navigationItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
          zoomDrawerController.close?.call();
        });
      },
      highlightColor: AppColor.orange.withOpacity(0.2),
      splashColor: AppColor.orange.withOpacity(0.1),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.primary.withOpacity(0.2),
              AppColor.primary.withOpacity(0.05),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              () {
                if (index == 0) return Icons.home;
                if (index == 1) return Icons.check_box;
                if (index == 2) return Icons.check_box_outline_blank;
                return Icons.delete;
              }(),
              size: 22.0,
              color:
                  index == selectedIndex ? Colors.amber[800] : AppColor.dark500,
            ),
            Text(
              () {
                if (index == 0) return 'All';
                if (index == 1) return 'Completed';
                if (index == 2) return 'Uncompleted';
                return 'Deleted';
              }(),
              style: TextStyle(
                color: index == selectedIndex
                    ? Colors.amber[800]
                    : AppColor.dark500,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
