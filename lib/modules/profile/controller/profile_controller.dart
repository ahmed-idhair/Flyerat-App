import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as d;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/widgets/feedback/app_toast.dart';
import 'package:offers/core/api/api_response.dart';
import 'package:offers/core/models/user/user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/services/fcm_service.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/http_service.dart';
import '../../base_controller.dart';
import '../../settings_page/controller/settings_page_controller.dart';

class ProfileController extends BaseController {
  User? user;
  XFile? image;
  final ImagePicker _picker = ImagePicker();
  final FCMService _fcmService = FCMService();

  @override
  void onInit() {
    super.onInit();
    if (storage.isAuth()) {
      updateUser();
    }
  }

  void updateUser() {
    user = storage.getUser();
    update(['updateUser']);
  }

  String formatPhoneNumberMasked(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return "";
    }

    String cleanNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    bool hasCountryCode = cleanNumber.startsWith('+');
    if (cleanNumber.length < 8) {
      return phoneNumber;
    }
    int prefixLength = hasCountryCode ? 3 : 2;
    String prefix = cleanNumber.substring(
      0,
      min(prefixLength, cleanNumber.length),
    );
    String suffix = cleanNumber.substring(max(0, cleanNumber.length - 4));
    return '$prefix *** *** $suffix';
  }

  String maskEmail(String? email) {
    if (email == null || email.isEmpty || !email.contains('@')) {
      return '';
    }

    List<String> parts = email.split('@');
    String username = parts[0];
    String domain = parts[1];
    String maskedUsername = '';
    if (username.length > 3) {
      maskedUsername =
          username.substring(0, 3) + ''.padRight(username.length - 3, '*');
    } else {
      maskedUsername = username[0] + ''.padRight(username.length - 1, '*');
    }
    List<String> domainParts = domain.split('.');

    String maskedDomain = ''.padRight(domainParts[0].length, '*');
    String maskedTLD = ''.padRight(domainParts[1].length, '*');

    return '$maskedUsername@$maskedDomain.$maskedTLD';
  }

  Future<void> updateImage() async {
    try {
      FocusScopeNode currentFocus = FocusScope.of(Get.context!);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.focusedChild?.unfocus();
      }
      EasyLoading.show();
      d.FormData? formData;
      Map<String, dynamic>? body;
      if (image != null) {
        String fileName = image!.path.split('/').last;
        formData = d.FormData.fromMap({
          'image': await d.MultipartFile.fromFile(
            image!.path,
            filename: fileName,
          ),
        });
      }
      final result = await httpService.request(
        url: ApiConstant.updateProfileImage,
        method: Method.POST,
        isUploadImg: image != null,
        formData: formData,
        params: body,
      );

      if (result != null) {
        var resp = ApiResponse.fromJsonModel(result.data, User.fromJson);
        if (resp.isSuccess == true) {
          if (resp.data != null) {
            image = null;
            user = resp.data!;
            storage.setUser(resp.data!);
            updateUser();
            if (Get.isRegistered<SettingsPageController>()) {
              Get.find<SettingsPageController>().updateUser();
            }
          }
        } else {
          AppToast.error(resp.message ?? "");
        }
      }
    } finally {
      EasyLoading.dismiss(animation: true);
    }
  }

  Future<void> logout(bool isDeleteAccount) async {
    try {
      EasyLoading.show();
      final result = await httpService.request(
        url: ApiConstant.logout,
        method: Method.POST,
      );
      if (result != null) {
        var resp = ApiResponse<void>.fromJson(result.data);
        if (resp.isSuccess == true) {
          if (isDeleteAccount == false) {
            AppToast.success(resp.message ?? "");
          }
          await _fcmService.unsubscribeFromUser(storage.getUser()!.id!);
          await _fcmService.unsubscribeFromUsers();
          storage.clearApp();
          Get.offAllNamed(AppRoutes.signIn);
        } else {
          AppToast.error(resp.message ?? "");
        }
      }
    } finally {
      EasyLoading.dismiss(animation: true);
    }
  }

  Future<void> selectImage() async {
    if (Platform.isAndroid) {
      final androidVersion = await DeviceInfoPlugin().androidInfo;
      if ((androidVersion.version.sdkInt) >= 33) {
        if (await Permission.camera.request().isGranted &&
            await Permission.photos.request().isGranted) {
          showPicker();
        } else {
          Map<Permission, PermissionStatus> statuses =
              await [Permission.storage, Permission.photos].request();
        }
      } else {
        if (await Permission.camera.request().isGranted &&
            await Permission.storage.request().isGranted) {
          showPicker();
        } else {
          Map<Permission, PermissionStatus> statuses =
              await [Permission.storage, Permission.camera].request();
        }
      }
    }
    if (Platform.isIOS) {
      showPicker();
    }
  }

  void showPicker() async {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(16.r),
              topEnd: Radius.circular(16.r),
            ),
          ),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(LangKeys.gallery.tr),
                onTap: () {
                  _imgFromGallery();
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(LangKeys.camera.tr),
                onTap: () {
                  _imgFromCamera();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _imgFromGallery() async {
    image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 80,
    );
    update(['selectImg']);
    if (image != null) {
      updateImage();
    }
    if (kDebugMode) {
      print(image?.path);
    }
  }

  _imgFromCamera() async {
    image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    update(['selectImg']);
    if (image != null) {
      updateImage();
    }
    if (kDebugMode) {
      print(image?.path);
    }
  }
}
