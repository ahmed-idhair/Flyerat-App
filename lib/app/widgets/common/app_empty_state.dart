import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/common/app_shimmer.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';

import '../../extensions/color.dart';

/// Empty state widget
class AppEmptyState extends StatelessWidget {
  final String? title;
  final String message;
  final String? icon;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const AppEmptyState({
    super.key,
    this.title,
    required this.message,
    this.icon,
    this.onActionPressed,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppUtils.getIconPath(icon ?? "ic_empty"),
              width: 118.0.w,
              height: 118.0.h,
              placeholderBuilder: (BuildContext context) => AppLoadingView(),
            ),
            // 16.verticalSpace,
            // AppCustomText(
            //   text: title ?? "",
            //   fontWeight: FontWeight.bold,
            //   fontSize: 16.sp,
            // ),
            20.verticalSpace,
            AppCustomText(
              text: message,
              fontWeight: FontWeight.w500,
              color: HexColor("404040"),
              fontSize: 14.sp,
            ),
            if (onActionPressed != null && actionText != null) ...[
              20.verticalSpace,
              AppButton(
                text: actionText!,
                variant: ButtonVariant.primary,
                onPressed: onActionPressed!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
