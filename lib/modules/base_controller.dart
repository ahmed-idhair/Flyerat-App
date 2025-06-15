import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../app/services/storage_service.dart';
import '../core/api/http_service.dart';

class BaseController extends GetxController {
  late HttpService httpService;
  late StorageService storage;

  @override
  onInit() {
    super.onInit();
    // print("Log httpService onInit");
    httpService = Get.find();
    storage = Get.find();

    // print("Log httpService onInit weww");
  }
}
