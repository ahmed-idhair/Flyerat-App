import 'package:get/get.dart';

import '../../modules/public_controller.dart';



class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(LanguageController(), permanent: true);
    Get.put(PublicController(), permanent: true);
    // Get.put(DownloadFileController());

    // Get.put(HomeController(), permanent: true);
  }
}
