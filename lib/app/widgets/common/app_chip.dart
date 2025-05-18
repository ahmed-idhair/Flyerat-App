import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offers/app/config/app_theme.dart';

/// Custom chip widget
class AppChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final double? height;

  const AppChip({
    super.key,
    required this.label,
    this.onTap,
    this.onDelete,
    this.backgroundColor,
    this.textColor,
    this.leadingIcon,
    this.leadingIconColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 32.h,
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacing12,
          vertical: AppTheme.spacing4,
        ),
        decoration: BoxDecoration(
          color:
              backgroundColor ?? AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusCircular),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 16.w,
                color: leadingIconColor ?? textColor ?? AppTheme.primaryColor,
              ),
              SizedBox(width: AppTheme.spacing4),
            ],
            Text(
              label,
              style: AppTheme.bodySmall.copyWith(
                color: textColor ?? AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onDelete != null) ...[
              SizedBox(width: AppTheme.spacing4),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: 16.w,
                  color: textColor ?? AppTheme.primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
