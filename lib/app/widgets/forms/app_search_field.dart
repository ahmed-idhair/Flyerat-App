import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/utils/app_utils.dart';

import '../../extensions/color.dart';

class AppSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final VoidCallback? onActionButtonPressed;
  final bool autofocus;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final Widget? prefix;

  // SVG icon paths
  final String searchIconPath;
  final String actionIconPath;

  // Action button options
  final bool showActionButton;
  final Color? actionButtonColor;
  final String? actionButtonTooltip;

  const AppSearchField({
    super.key,
    this.hintText = 'Search here for any thing',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onActionButtonPressed,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
    this.backgroundColor,
    this.height,
    this.margin,
    this.searchIconPath = 'ic_search',
    this.actionIconPath = 'ic_refresh',
    this.showActionButton = false,
    this.actionButtonColor,
    this.actionButtonTooltip,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: height ?? 45.h,
            margin: margin,
            decoration: BoxDecoration(
              color: backgroundColor ?? HexColor("F9F9F9"),
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: (_) => onSubmitted?.call(),
              autofocus: autofocus,
              readOnly: readOnly,
              onTap: onTap,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                prefixIcon:
                    prefix ??
                    Icon(Icons.search, color: Colors.grey, size: 20.sp),
                border: InputBorder.none,
                // contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ),
        if (showActionButton) ...[
          SizedBox(width: 8.w),
          Container(
            height: height ?? 45.h,
            width: height ?? 45.h,
            decoration: BoxDecoration(
              color: actionButtonColor ?? AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: IconButton(
              onPressed: onActionButtonPressed,
              icon: SvgPicture.asset(
                AppUtils.getIconPath(actionIconPath),
                width: 20.w,
                height: 20.h,
                color: Colors.white,
              ),
              tooltip: actionButtonTooltip,
            ),
          ),
        ],
      ],
    );
  }
}
