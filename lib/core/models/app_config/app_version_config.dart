import 'package:package_info_plus/package_info_plus.dart';

import 'app_config.dart';

class AppVersionConfig {
  String appVersionAndroid;
  String appVersionIOS;
  String appUpdateMessageAr;
  String appUpdateTitleAr;
  String textUpdateNowAr;
  String textUpdateLaterAr;
  String appUpdateMessageEn;
  String appUpdateTitleEn;
  String textUpdateNowEn;
  String textUpdateLaterEn;
  String appUpdateLink;
  bool isForceUpdate;
  String appStoreLink;
  String playStoreLink;

  AppVersionConfig({
    this.appVersionAndroid = "1.0.0",
    this.appVersionIOS = "1.0.0",
    this.appUpdateMessageAr = "",
    this.appUpdateTitleAr = "",
    this.textUpdateNowAr = "",
    this.textUpdateLaterAr = "",
    this.appUpdateMessageEn = "",
    this.appUpdateTitleEn = "",
    this.textUpdateNowEn = "",
    this.textUpdateLaterEn = "",
    this.appUpdateLink = "",
    this.isForceUpdate = false,
    this.appStoreLink = "",
    this.playStoreLink = "",
  });

  factory AppVersionConfig.fromConfigItems(List<AppConfig> items) {
    Map<String, String> configMap = {};

    // Convert list to map for easy access
    for (var item in items) {
      if (item.key != null && item.value != null) {
        configMap[item.key!] = item.value!;
      }
    }

    return AppVersionConfig(
      appVersionAndroid: configMap['app_version_android'] ?? "1.0.0",
      appVersionIOS: configMap['app_version_ios'] ?? "1.0.0",
      appUpdateMessageAr: configMap['app_update_message_ar'] ?? "",
      appUpdateTitleAr: configMap['app_update_title_ar'] ?? "",
      textUpdateNowAr: configMap['text_update_now_ar'] ?? "",
      textUpdateLaterAr: configMap['text_update_later_ar'] ?? "",
      appUpdateMessageEn: configMap['app_update_message_en'] ?? "",
      appUpdateTitleEn: configMap['app_update_title_en'] ?? "",
      textUpdateNowEn: configMap['text_update_now_en'] ?? "",
      textUpdateLaterEn: configMap['text_update_later_en'] ?? "",
      appUpdateLink: configMap['app_update_link'] ?? "",
      isForceUpdate: (configMap['app_update_force'] ?? "0") == "1",
      appStoreLink: configMap['app_store_link'] ?? "",
      playStoreLink: configMap['play_store_link'] ?? "",
    );
  }

}
