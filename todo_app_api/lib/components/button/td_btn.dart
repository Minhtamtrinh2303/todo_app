import 'package:flutter/material.dart';

class TDBtn extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool invertedColors;
  const TDBtn(
      {required this.text,
      required this.onPressed,
      this.invertedColors = false,
      Key? key})
      : super(key: key);

      
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          alignment: Alignment.center,
          side: MaterialStateProperty.all(
              BorderSide(width: 1, color: primaryColor)),
          padding: MaterialStateProperty.all(
              const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
          backgroundColor: MaterialStateProperty.all(
              invertedColors ? accentColor : primaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          )),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: invertedColors ? primaryColor : accentColor,
          fontSize: 16,
        ),
      ),
    );
  }
}