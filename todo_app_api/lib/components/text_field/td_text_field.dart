import 'package:flutter/material.dart';
import '../../resources/app_color.dart';

class TdTextField extends StatelessWidget {
  const TdTextField({
    super.key,
    this.controller,
    this.keyboardType,
    required this.hintText,
    this.prefixIcon,
    this.textInputAction,
    this.validator,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hintText;
  final Icon? prefixIcon;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  // final Function(String)? onChanged;
  // final Function()? onEditingComplete;
  // final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            height: 48.0,
            decoration: BoxDecoration(
              color: AppColor.grey.withOpacity(0.32),
              //border: Border.all(color: Colors.red, width: 1.2),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        Positioned(
          child: TextFormField(
            // keyboardType: keyboardType,
            textAlignVertical: const TextAlignVertical(y: 0.0),
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16.0),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(color: AppColor.grey),
              prefixIcon: prefixIcon,
              // errorStyle: AppStyle.h14Normal.copyWith(
              //   color: Colors.red,
              // ),
              // errorMaxLines: 1,
            ),
            textInputAction: textInputAction,
            style: const TextStyle(color: AppColor.brown, fontSize: 16.0),
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}