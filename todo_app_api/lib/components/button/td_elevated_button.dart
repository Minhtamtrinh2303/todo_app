import 'package:flutter/material.dart';

class TdElevatedButton extends StatelessWidget {
  TdElevatedButton({
    super.key,
    this.onPressed,
    this.height = 48.0,
    this.color = Colors.red,
    this.borderColor = Colors.red,
    required this.text,
    this.textColor = Colors.white,
    this.fontSize = 16.0,
    this.icon,
    BorderRadius? borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.isDisable = false,
    Color? splashColor,
    Color? highlightColor,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(10.0),
        splashColor = splashColor ?? Colors.red.withOpacity(0.16),
        highlightColor = highlightColor ?? Colors.red.withOpacity(0.30);

  TdElevatedButton.small({
    super.key,
    this.onPressed,
    this.height = 38.0,
    this.color = Colors.red,
    this.borderColor = Colors.red,
    required this.text,
    this.textColor = Colors.white,
    this.fontSize = 14.6,
    this.icon,
    BorderRadius? borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.isDisable = false,
    Color? splashColor,
    Color? highlightColor,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(8.0),
        splashColor = splashColor ?? Colors.red.withOpacity(0.16),
        highlightColor = highlightColor ?? Colors.red.withOpacity(0.30);

  final VoidCallback? onPressed;
  final double height;
  final Color color;
  final Color borderColor;
  final String text;
  final Color textColor;
  final double fontSize;
  final Icon? icon;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isDisable;
  final Color splashColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      elevation: 5.0,
      surfaceTintColor: Colors.transparent,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: isDisable ? null : onPressed,
        splashColor: splashColor,
        highlightColor: highlightColor,
        child: Ink(
          padding: padding,
          height: height,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor, width: 1.2),
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 3.6),
              ],
              isDisable
                  ? Center(
                      child: SizedBox.square(
                        dimension: height - 16.0,
                        child: CircularProgressIndicator(
                            color: textColor, strokeWidth: 2.6),
                      ),
                    )
                  : Text(
                      text,
                      style: TextStyle(
                          color: textColor,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
