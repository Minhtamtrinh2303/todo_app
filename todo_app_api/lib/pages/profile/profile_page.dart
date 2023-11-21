import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_api/components/button/td_elevated_button.dart';
import 'package:todo_app_api/components/snack_bar/td_snack_bar.dart';
import 'package:todo_app_api/components/snack_bar/top_snack_bar.dart';
import 'package:todo_app_api/components/text_field/td_text_field.dart';
import 'package:todo_app_api/constants/app_constant.dart';
import 'package:todo_app_api/gen/assets.gen.dart';
import 'package:todo_app_api/models/app_user_model.dart';
import 'package:todo_app_api/pages/main_page.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/remote/account_services.dart';
import 'package:todo_app_api/services/remote/body/profile_body.dart';
import 'package:todo_app_api/utils/utils.dart';
import 'package:todo_app_api/utils/validator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.pageIndex});
  final int pageIndex;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppUserModel appUser = AppUserModel();

  final _accountServices = AccountServices();
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();

  File? fileAvatar;

  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> _pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result == null) return;
    fileAvatar = File(result.files.single.path!);

    setState(() {});
  }

  Future<void> getProfile() async {
    _accountServices.getProfile().then((response) {
      if (response.isSuccess) {
        _fullNameController.text = response.body?.name ?? '';
        _emailController.text = response.body?.email ?? '';
        appUser = response.body ?? AppUserModel();
        setState(() {});
      }
    }).catchError((onError) {
      log('message $onError');
    });
  }

  Future<String?> uploadFile() async {
    if (fileAvatar == null) return null;
    return _accountServices.uploadFile(fileAvatar!).then((response) {
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

  Future<bool?> updateProfile() async {
    setState(() => isLoad = true);
    final body = ProfileBody()..name = _fullNameController.text.trim();
    fileAvatar != null ? body.avatar = await uploadFile() : null;

    return _accountServices.updateProfile(body).then((response) {
      if (response.isSuccess) {
        setState(() => isLoad = false);
      }
      return true;
    }).catchError((onError) {
      setState(() => isLoad = false);
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
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0)
                .copyWith(top: MediaQuery.of(context).padding.top + 38.0),
            children: [
              const Text(
                'My Profile',
                style: TextStyle(
                  color: AppColor.red,
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 38.0),
              Center(
                child: GestureDetector(
                  onTap: _pickAvatar,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35.0),
                        child: Container(
                          width: 70.0,
                          height: 70.0,
                          color: fileAvatar != null
                              ? Colors.transparent
                              : Colors.orange.shade100,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: fileAvatar == null
                                ? Image.network(
                                    AppConstant.baseImage(appUser.avatar ?? ''),
                                    errorBuilder: (context, error, stackTrace) {
                                      return Assets.images.defaultAvatar
                                          .image();
                                    },
                                    loadingBuilder:
                                        (_, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  )
                                : Image.file(fileAvatar ?? File('')),
                          ),
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
              ),
              const SizedBox(height: 42.0),
              TdTextField(
                controller: _fullNameController,
                textInputAction: TextInputAction.next,
                hintText: "Full Name",
                prefixIcon: const Icon(Icons.person, color: AppColor.orange),
                validator: Validator.requiredValidator,
              ),
              const SizedBox(height: 18.0),
              TdTextField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                hintText: "Email",
                readOnly: true,
                prefixIcon: const Icon(Icons.email, color: AppColor.orange),
                validator: Validator.emailValidator,
              ),
              const SizedBox(height: 72.0),
              TdElevatedButton(
                isDisable: isLoad,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateProfile().then((value) {
                      if (value == true) {
                        Utils.pushAndRemoveUtil(
                            context,
                            MainPage(
                              title: 'Todos',
                              pageIndex: widget.pageIndex,
                            ));
                      }
                    });
                  }
                },
                text: 'Save',
              ),
              const SizedBox(height: 20.0),
              TdElevatedButton(
                onPressed: () {
                  // Route route = MaterialPageRoute(
                  //     builder: (context) => MainPage(
                  //           title: 'Todos',
                  //           pageIndex: widget.pageIndex,
                  //         ));
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     route, (Route<dynamic> route) => false);
                  Navigator.pop(context);
                },
                text: 'Back',
                color: AppColor.white,
                textColor: AppColor.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
