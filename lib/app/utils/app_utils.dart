import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Flutter Utility functions
class AppUtils {
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String getImagePath(String name, {String format = 'png'}) {
    return 'assets/images/$name.$format';
  }

  static String getIconPath(String name, {String format = 'svg'}) {
    return 'assets/icons/$name.$format';
  }

  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    // Simple date formatting for common formats
    if (format == 'yyyy-MM-dd') {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } else if (format == 'dd/MM/yyyy') {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } else if (format == 'MM/dd/yyyy') {
      return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    } else if (format == 'yyyy-MM-dd HH:mm') {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return date.toString();
  }

  static String formatDatedMMMMyyyy(String dateStr) {
    final DateTime date = DateTime.parse(dateStr);
    const List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    String day = date.day.toString().padLeft(2, '0');
    String month = monthNames[date.month - 1];
    String year = date.year.toString();

    return '$day $month $year';
  }

  static String timeAgo(String date) {
    final now = DateTime.now();
    DateTime  dateTime = DateTime.parse(date);
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  static String getDaysLeft(String? endDates) {
    if (endDates == null || endDates == "") {
      return '-';
    }
    try {
      // Parse the end date from API
      final DateTime endDate = DateTime.parse(endDates);
      final DateTime today = DateTime.now();

      // Calculate the difference in days
      final int daysLeft = endDate.difference(today).inDays;

      if (daysLeft < 0) {
        return LangKeys.expired.tr;
      } else if (daysLeft == 0) {
        return LangKeys.lastDay.tr;
      } else if (daysLeft == 1) {
        return LangKeys.dayLeft.tr;
      } else {
        return '$daysLeft ${LangKeys.daysLeft.tr}';
      }
    } catch (e) {
      // In case of parsing error
      return '-- days left';
    }
  }

  static void shareAppLink(String textShare) {
    final String appName = 'Offers';
    final String appStoreLink = 'https://apps.apple.com/app/your-app-id';
    final String playStoreLink =
        'https://play.google.com/store/apps/details?id=your.package.name';
    final String message =
        '$appName\n\n'
        '$textShare\n\n'
        'Android: $playStoreLink\n\n'
        'iOS: $appStoreLink';

    Share.share(message);
  }

  static void openUrlBrowser(String url) async {
    if (url.isEmpty) return;

    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not launch this live stream',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Function to open Google Maps with specific coordinates
  static void openLocationInGoogleMaps(
    String lat,
    String lng, {
    String label = '',
  }) async {
    if (lat.isEmpty || lng.isEmpty) {
      Get.snackbar('Error', 'Location coordinates not available');
      return;
    }

    // Create Google Maps URL (with optional label/name)
    final String googleMapsUrl =
        label.isEmpty
            ? 'https://www.google.com/maps/search/?api=1&query=$lat,$lng'
            : 'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$label';

    // Create URI for launching
    final Uri uri = Uri.parse(googleMapsUrl);

    // Try to launch the URL
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode:
              LaunchMode
                  .externalApplication, // This opens in the Google Maps app if installed
        );
      } else {
        // Fallback for web or if Google Maps isn't installed
        final String fallbackUrl = 'https://maps.google.com/?q=$lat,$lng';
        final Uri fallbackUri = Uri.parse(fallbackUrl);
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri);
        } else {
          Get.snackbar('Error', 'Could not open maps');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to open maps: $e');
    }
  }
}
