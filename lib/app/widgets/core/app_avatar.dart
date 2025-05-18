import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';

/// Avatar widget with options for image, text or icon
class AppAvatar extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final String? text;
  final IconData? icon;
  final Color? backgroundColor;
  final Border? border;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.size = 40,
    this.imageUrl,
    this.text,
    this.icon,
    this.backgroundColor,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarWidget = Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.grey.shade200,
        border: border,
        image:
            imageUrl != null
                ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
                : null,
      ),

      child:
          imageUrl == null
              ? Center(
                child:
                    text != null
                        ? AppCustomText(
                          text: _getInitials(),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: size.w * 0.4,
                        )
                        : Icon(icon, color: Colors.white, size: size.w * 0.5),
              )
              : null,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatarWidget);
    }

    return avatarWidget;
  }

  String _getInitials() {
    if (text == null || text!.isEmpty) return '';
    final List<String> words = text!.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    } else {
      return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
    }
  }
}
