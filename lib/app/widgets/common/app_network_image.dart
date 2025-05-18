import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_shimmer.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double width;
  final double height;

  // General radius options
  final double? borderRadius;
  final BorderRadiusGeometry? circular;

  // Individual corner radius options
  final double? topStart;
  final double? topEnd;
  final double? bottomStart;
  final double? bottomEnd;

  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Widget? errorWidget;

  // Parameter for custom error image
  final String? errorImagePath;

  // Default image path (constant)
  static const String defaultImagePath = 'assets/images/default_image.png';

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    required this.fit,
    required this.width,
    required this.height,
    this.borderRadius,
    this.circular,
    this.topStart,
    this.topEnd,
    this.bottomStart,
    this.bottomEnd,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.errorWidget,
    this.errorImagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Determine border radius
    BorderRadiusGeometry? finalBorderRadius;

    if (circular != null) {
      finalBorderRadius = circular;
    } else if (topStart != null ||
        topEnd != null ||
        bottomStart != null ||
        bottomEnd != null) {
      // If any specific corner is specified, use BorderRadiusDirectional
      finalBorderRadius = BorderRadiusDirectional.only(
        topStart: Radius.circular(topStart ?? 0),
        topEnd: Radius.circular(topEnd ?? 0),
        bottomStart: Radius.circular(bottomStart ?? 0),
        bottomEnd: Radius.circular(bottomEnd ?? 0),
      );
    } else if (borderRadius != null) {
      finalBorderRadius = BorderRadius.circular(borderRadius!);
    }

    // Determine shape
    final BoxShape shape =
        finalBorderRadius == null ? BoxShape.circle : BoxShape.rectangle;

    // Shimmer loading widget
    final shimmerLoadingWidget = AppShimmer(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: shape,
          borderRadius: finalBorderRadius,
        ),
      ),
    );

    // Custom error handler that tries multiple fallbacks
    Widget handleError(BuildContext context, String url, dynamic error) {
      // If user-provided error widget exists, use it
      if (errorWidget != null) {
        return errorWidget!;
      }

      // Try to load user-provided error image
      if (errorImagePath != null) {
        return Image.asset(
          errorImagePath!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            // If that fails, fall back to default image
            return Image.asset(
              defaultImagePath,
              width: width,
              height: height,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // If all image assets fail, show error icon as last resort
                return Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    shape: shape,
                    borderRadius: finalBorderRadius,
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 24.r,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            );
          },
        );
      }

      // If no errorImagePath provided, directly try default image
      return Image.asset(
        defaultImagePath,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // If default image fails, show error icon
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: shape,
              borderRadius: finalBorderRadius,
              color: Colors.grey[200],
            ),
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                size: 24.r,
                color: Colors.grey[600],
              ),
            ),
          );
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => shimmerLoadingWidget,
      errorWidget: handleError,
      fadeOutDuration: const Duration(seconds: 0),
      fadeInDuration: const Duration(seconds: 0),
      imageBuilder:
          (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: shape,
              borderRadius: finalBorderRadius,
              image: DecorationImage(fit: fit, image: imageProvider),
            ),
          ),
    );
  }
}
