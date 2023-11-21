import 'package:flutter/material.dart';
import 'package:todo_app_api/components/button/td_elevated_button.dart';
import 'package:todo_app_api/resources/app_color.dart';

class TDDialog extends StatefulWidget {
  const TDDialog(
      {Key? key, required this.title, this.subText, this.icon, this.onPressed})
      : super(key: key);
  final String title;
  final String? subText;
  final IconData? icon;
  final Function()? onPressed;

  @override
  State<TDDialog> createState() => _TDDialogState();
}

class _TDDialogState extends State<TDDialog> {
  final primaryColor = AppColor.primary;

  final accentColor = AppColor.white;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 25,
                  child: Icon(
                    widget.icon,
                    color: accentColor,
                  )),
              const SizedBox(height: 15),
              Text(widget.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 3.5),
              Text(widget.subText ?? "",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w300)),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TdElevatedButton.small(
                      text: "Yes",
                      color: AppColor.primary,
                      borderColor: AppColor.primary,
                      textColor: AppColor.white,
                      splashColor: AppColor.white.withOpacity(0.1),
                      highlightColor: AppColor.white.withOpacity(0.2),
                      onPressed: widget.onPressed,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TdElevatedButton.small(
                      text: "No",
                      color: AppColor.dark500,
                      borderColor: AppColor.dark500,
                      textColor: AppColor.white,
                      splashColor: AppColor.white.withOpacity(0.1),
                      highlightColor: AppColor.white.withOpacity(0.2),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
