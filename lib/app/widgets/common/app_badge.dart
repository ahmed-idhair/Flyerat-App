import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offers/app/config/app_theme.dart';

class AppBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showZero;
  final double? size;

  const AppBadge({
    super.key,
    required this.child,
    required this.count,
    this.backgroundColor,
    this.textColor,
    this.showZero = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0 || showZero)
          Positioned(
            right: -5.w,
            top: -5.w,
            child: Container(
              height: size ?? 18.w,
              width: size ?? 18.w,
              decoration: BoxDecoration(
                color: backgroundColor ?? AppTheme.errorColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: (size != null) ? size! * 0.6 : 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
