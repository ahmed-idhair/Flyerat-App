import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool? isRequired;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool autofocus;
  final AutovalidateMode autovalidateMode;
  final bool enabled;

  // New parameters for character counter
  final bool showCounter;
  final Color counterColor;

  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.isRequired = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.onTap,
    this.autofocus = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.enabled = true,
    // Default value for counter is false
    this.showCounter = false,
    this.counterColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: enabled ? Colors.black : Colors.grey,
              ),
            ),
            if (isRequired == true)
              Text(
                " *",
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        8.verticalSpace,
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          onTap: onTap,
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          style: AppTheme.bodyMedium.copyWith(
            color: enabled ? Colors.black : Colors.grey,
          ),
          // Hide the default counter text widget
          buildCounter: showCounter ? _buildCustomCounter : null,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondaryColor.withValues(alpha: 0.7),
            ),
            errorText: errorText,
            helperText: helperText,
            // Hide the default counter
            counterText: showCounter ? null : '',
            prefixIcon:
                prefixIcon != null
                    ? Icon(prefixIcon, color: enabled ? null : Colors.grey)
                    : null,
            suffixIcon:
                suffixIcon != null
                    ? IconButton(
                      icon: Icon(
                        suffixIcon,
                        color: enabled ? null : Colors.grey,
                      ),
                      onPressed: enabled ? onSuffixIconPressed : null,
                    )
                    : null,
            filled: true,
            isDense: true,
            fillColor: enabled ? AppTheme.surfaceColor : Colors.grey.shade200,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppTheme.borderRadiusTextField,
              ),
              borderSide: BorderSide(
                color: AppTheme.dividerColor,
                width: 0.3.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppTheme.borderRadiusTextField,
              ),
              borderSide: BorderSide(
                color: AppTheme.dividerColor,
                width: 0.3.w,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppTheme.borderRadiusTextField,
              ),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 0.3.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppTheme.borderRadiusTextField,
              ),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppTheme.borderRadiusTextField,
              ),
              borderSide: BorderSide(color: AppTheme.errorColor, width: 0.3.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppTheme.borderRadiusTextField,
              ),
              borderSide: BorderSide(color: AppTheme.errorColor, width: 0.3.w),
            ),
          ),
        ),
      ],
    );
  }

  // Custom counter builder function
  Widget? _buildCustomCounter(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) {
    return Container(
      padding: EdgeInsets.only(top: 4.h),
      alignment: AlignmentDirectional.bottomStart,
      child: AppCustomText(
        text: '$currentLength / $maxLength',
        fontSize: 14.sp,
        color: counterColor,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
