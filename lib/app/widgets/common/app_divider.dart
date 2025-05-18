import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offers/app/config/app_theme.dart';

class AppDivider extends StatelessWidget {
  final Color? color;
  final double height;
  final double thickness;
  final EdgeInsetsGeometry? margin;

  const AppDivider({
    super.key,
    this.color,
    this.height = 1.0,
    this.thickness = 1.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color ?? AppTheme.dividerColor,
            width: thickness.w,
          ),
        ),
      ),
    );
  }
}
