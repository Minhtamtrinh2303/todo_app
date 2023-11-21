import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo_app_api/resources/app_color.dart';

class TdAvatar extends StatelessWidget {
  const TdAvatar({
    super.key,
    this.avatar,
    this.radius = 26.0,
    this.isActive = false,
  });

  final String? avatar;
  final double radius;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: avatar?.startsWith('http') ?? false
                ? Image.network(
                    avatar ?? '',
                    fit: BoxFit.cover,
                    width: radius * 2,
                    height: radius * 2,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: radius * 2,
                        height: radius * 2,
                        color: Colors.orange,
                        child: const Center(
                          child: Icon(Icons.error_rounded, color: Colors.white),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox.square(
                        dimension: radius * 2,
                        child: const Center(
                          child: SizedBox.square(
                            dimension: 24.6,
                            child: CircularProgressIndicator(
                              color: AppColor.pink,
                              strokeWidth: 2.0,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Image.file(File(avatar ?? ''),
                    fit: BoxFit.cover, width: radius * 2, height: radius * 2),
          ),
        ),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          child: avatar == null
              ? Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.pink)),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 14.0,
                    color: Colors.pink,
                  ),
                )
              : CircleAvatar(
                  backgroundColor: AppColor.white,
                  radius: radius / 4.6 + 1.8,
                  child: CircleAvatar(
                    backgroundColor:
                        isActive ? AppColor.green : AppColor.yellow,
                    radius: radius / 4.6,
                  ),
                ),
        ),
      ],
    );
  }
}
