import 'package:flutter/material.dart';
import '../../resources/app_color.dart';

class TdTextFieldPassword extends StatefulWidget {
  const TdTextFieldPassword({
    super.key,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.onFieldSubmitted,
    required this.hintText,
    this.textInputAction,
    this.validator,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Function(String)? onFieldSubmitted;
  final String hintText;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  // final Function()? onEditingComplete;
  // final FocusNode? focusNode;

  @override
  State<TdTextFieldPassword> createState() => _TdTextFieldPasswordState();
}

class _TdTextFieldPasswordState extends State<TdTextFieldPassword> {
  bool showPassword = false;

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
            controller: widget.controller,
            onChanged: widget.onChanged,
            obscureText: !showPassword,
            keyboardType: widget.keyboardType,
            onFieldSubmitted: widget.onFieldSubmitted,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16.0),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: AppColor.grey),
              prefixIcon: const Icon(Icons.password, color: AppColor.orange),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => showPassword = !showPassword),
                child: Icon(
                  Icons.remove_red_eye_rounded,
                  color: showPassword ? AppColor.brown : AppColor.green,
                ),
              ),
              // errorStyle: AppStyle.h14Normal.copyWith(
              //   color: Colors.red,
              // ),
              // errorMaxLines: 1,
            ),
            textInputAction: widget.textInputAction,
            style: const TextStyle(color: AppColor.brown, fontSize: 16.0),
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}
