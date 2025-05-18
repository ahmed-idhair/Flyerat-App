import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/core/api/api_response.dart';
import 'package:offers/core/models/page_data.dart';
import 'package:offers/core/models/settings_obj.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/api/api_constant.dart';
import '../../../core/api/http_service.dart';
import '../../base_controller.dart';

/// Controller for displaying static content pages in a WebView
/// Handles loading page content from API and configuring the WebView
class PageViewController extends BaseController {
  // State variables
  var isLoading = false.obs;
  var socialMediaList = <SettingsObj>[].obs;
  var data = "".obs;

  // Page metadata
  var title = "";
  var key = "";

  // WebView controller
  late WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    // Initialize WebView controller
    webViewController = WebViewController();

    // Get page parameters from arguments
    key = Get.arguments['key'];
    title = Get.arguments['title'];

    // Load page content
    getPage();

    getSocialMedia();
  }

  /// Fetches page content from the API and configures the WebView
  Future<void> getPage() async {
    try {
      // Show loading indicator
      isLoading(true);

      // Make API request to get page content
      final result = await httpService.request(
        url: "${ApiConstant.pages}/$key",
        method: Method.GET,
      );

      // Process response
      if (result != null) {
        var resp = ApiResponse.fromJsonModel(result.data, PageData.fromJson);
        data.value = resp.data?.content ?? "";

        // Configure WebView if content is available
        if (data.value.isNotEmpty) {
          webViewController =
              WebViewController()
                // Enable JavaScript
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                // Set transparent background
                ..setBackgroundColor(const Color(0x00000000))
                // Load HTML content
                ..loadHtmlString(data.value)
                // Set navigation delegate for events
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onPageFinished: (String url) {
                      // Set text direction based on app language
                      webViewController.runJavaScript('''
                    document.body.setAttribute("dir", "${storage.getLanguageCode() == "ar" ? "rtl" : "ltr"}");
                    document.body.style.textAlign = "${storage.getLanguageCode() == "ar" ? "right" : "left"}";
                  ''');
                    },
                    onWebResourceError: (WebResourceError error) {},
                    onPageStarted: (String url) {},
                    onProgress: (int progress) {},
                  ),
                );
        }
      }
    } finally {
      // Hide loading indicator
      isLoading(false);
    }
  }

  Future<void> getSocialMedia() async {
    try {
      // Show loading indicator
      // isLoading(true);

      // Make API request to get page content
      final result = await httpService.request(
        url: ApiConstant.socialMediaData,
        method: Method.GET,
      );
      // Process response
      if (result != null) {
        var resp = ApiResponse.fromJsonList(result.data, SettingsObj.fromJson);
        socialMediaList.value = resp.data ?? [];
        socialMediaList.removeWhere((element) => element.key == "linked-in");
      }
    } finally {
      // Hide loading indicator
      // isLoading(false);
    }
  }

  String getIconKey(String key) {
    switch (key) {
      case 'facebook':
        return 'ic_fb';
      case 'twitter-x':
        return 'ic_twitter';
      case 'instagram':
        return 'ic_instagram';
      case 'youtube':
        return 'ic_youtube';
      default:
        return 'ic_fb';
    }
  }

  Future<void> launchURL(String? url) async {
    if (url == null || url.isEmpty) {
      return;
    }
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Handle error - couldn't launch URL
      Get.snackbar('Error', 'Could not open the link');
    }
  }
}
