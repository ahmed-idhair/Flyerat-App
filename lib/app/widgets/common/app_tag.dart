import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offers/app/config/app_theme.dart';

/// Tag for text badges or status indicators
class AppTag extends StatelessWidget {
  final String text;
  final TagVariant variant;
  final TagSize size;

  const AppTag({
    super.key,
    required this.text,
    this.variant = TagVariant.primary,
    this.size = TagSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getPaddingHorizontal(),
        vertical: _getPaddingVertical(),
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
      child: Text(text, style: _getTextStyle()),
    );
  }

  double _getPaddingHorizontal() {
    switch (size) {
      case TagSize.small:
        return AppTheme.spacing8;
      case TagSize.medium:
        return AppTheme.spacing12;
      case TagSize.large:
        return AppTheme.spacing16;
    }
  }

  double _getPaddingVertical() {
    switch (size) {
      case TagSize.small:
        return 2.h;
      case TagSize.medium:
        return 4.h;
      case TagSize.large:
        return 6.h;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case TagSize.small:
        return AppTheme.borderRadiusSmall;
      case TagSize.medium:
        return AppTheme.borderRadiusMedium;
      case TagSize.large:
        return AppTheme.borderRadiusLarge;
    }
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case TagVariant.primary:
        return AppTheme.primaryColor.withValues(alpha: 0.1);
      case TagVariant.secondary:
        return AppTheme.secondaryColor.withValues(alpha: 0.1);
      case TagVariant.success:
        return AppTheme.successColor.withValues(alpha: 0.1);
      case TagVariant.error:
        return AppTheme.errorColor.withValues(alpha: 0.1);
      case TagVariant.warning:
        return AppTheme.warningColor.withValues(alpha: 0.1);
    }
  }

  TextStyle _getTextStyle() {
    final Color textColor;
    switch (variant) {
      case TagVariant.primary:
        textColor = AppTheme.primaryColor;
        break;
      case TagVariant.secondary:
        textColor = AppTheme.secondaryColor;
        break;
      case TagVariant.success:
        textColor = AppTheme.successColor;
        break;
      case TagVariant.error:
        textColor = AppTheme.errorColor;
        break;
      case TagVariant.warning:
        textColor = AppTheme.warningColor;
        break;
    }

    switch (size) {
      case TagSize.small:
        return AppTheme.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        );
      case TagSize.medium:
        return AppTheme.bodyMedium.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        );
      case TagSize.large:
        return AppTheme.bodyLarge.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        );
    }
  }
}

enum TagVariant { primary, secondary, success, error, warning }

enum TagSize { small, medium, large }
