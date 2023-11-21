import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_app_api/resources/app_color.dart';

class BounceMonoButton extends StatelessWidget {
  final String text;
  final String? iconLeft;
  final String? iconRight;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final Color fontColor;
  final FontWeight? fontWeight;
  final double iconSize;
  final BorderRadiusGeometry borderRadius;
  final MainAxisSize mainAxisSize;
  final bool isLoading;
  final VoidCallback? onPressed;

  BounceMonoButton(
      {super.key,
      required this.text,
      this.iconLeft,
      this.iconRight,
      this.backgroundColor = AppColor.green,
      this.padding =
          const EdgeInsets.symmetric(vertical: 14.5, horizontal: 40.0),
      this.fontSize = 16.0,
      this.fontColor = AppColor.white,
      this.fontWeight,
      this.iconSize = 24.0,
      BorderRadiusGeometry? borderRadius,
      this.mainAxisSize = MainAxisSize.max,
      this.isLoading = false,
      this.onPressed})
      : borderRadius = borderRadius ?? BorderRadius.circular(16.0);
  BounceMonoButton.small(
      {super.key,
      required this.text,
      this.iconLeft,
      this.iconRight,
      this.backgroundColor = AppColor.pink,
      this.padding =
          const EdgeInsets.symmetric(vertical: 11.5, horizontal: 12.0),
      this.fontSize = 12.0,
      this.fontColor = AppColor.white,
      this.fontWeight,
      this.iconSize = 20.0,
      BorderRadiusGeometry? borderRadius,
      this.mainAxisSize = MainAxisSize.max,
      this.isLoading = false,
      this.onPressed})
      : borderRadius = borderRadius ?? BorderRadius.circular(10.0);
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: onPressed == null ? AppColor.grey : backgroundColor,
      splashColor: fontColor.withOpacity(0.1),
      highlightColor: fontColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      elevation: 0.0,
      focusElevation: 0.0,
      hoverElevation: 0.0,
      highlightElevation: 0.0,
      padding: padding,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: mainAxisSize,
        children: [
          if (iconLeft != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SvgPicture.asset(iconLeft!,
                  colorFilter: ColorFilter.mode(
                      onPressed == null ? AppColor.white : fontColor,
                      BlendMode.color),
                  height: iconSize,
                  fit: BoxFit.cover),
            ),
          Flexible(
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: CircularProgressIndicator(
                          strokeWidth: iconSize / 12.0, color: fontColor),
                    ),
                  )
                : Text(text,
                    // style: AppStyle.body16Semibold.copyWith(
                    //     fontSize: fontSize,
                    //     fontWeight: fontWeight,
                    //     color: onPressed == null ? AppColor.white : fontColor),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
          ),
          if (iconRight != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SvgPicture.asset(iconRight!,
                  colorFilter: ColorFilter.mode(
                      onPressed == null ? AppColor.white : fontColor,
                      BlendMode.color),
                  height: iconSize,
                  fit: BoxFit.cover),
            ),
        ],
      ),
    );
  }
}
