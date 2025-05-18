import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offers/app/config/app_theme.dart';

/// Radio button with custom styling
class AppRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T>? onChanged;
  final String label;
  final bool isDisabled;
  final Color? activeColor;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.isDisabled = false,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : () => onChanged?.call(value),
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppTheme.spacing4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24.w,
              width: 24.w,
              child: Radio<T>(
                value: value,
                groupValue: groupValue,
                onChanged:
                    isDisabled ? null : (val) => onChanged?.call(val as T),
                activeColor: activeColor ?? AppTheme.primaryColor,
              ),
            ),
            SizedBox(width: AppTheme.spacing8),
            Flexible(
              child: Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  color:
                      isDisabled
                          ? AppTheme.textSecondaryColor
                          : AppTheme.textPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
