import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class InlineVideoPlayerController extends GetxController {
  // تخزين متحكمات الفيديو لكل عنصر في السلايدر
  final Map<int, ChewieController?> videoControllers = {};

  // تخزين حالة التحميل لكل فيديو
  final Map<int, RxBool> loadingStates = {};

  // تخزين حالة الخطأ لكل فيديو
  final Map<int, RxBool> errorStates = {};

  // للتحقق من نوع الفيديو/صورة
  final Map<int, RxString> mediaTypes = {};

  // لتخزين مسارات الوسائط
  final Map<int, RxString> mediaPaths = {};

  // تهيئة متحكم وسائط (فيديو أو صورة) للمؤشر الحالي
  void initMediaController(int index, String url, {String type = 'video'}) {
    if (url.isEmpty) return;

    // تخزين نوع الوسائط ومسارها
    mediaTypes[index] = type.obs;
    mediaPaths[index] = url.obs;

    // إذا كان نوع الوسائط صورة، لا داعي لإنشاء متحكم فيديو
    if (type.toLowerCase() == 'image') return;

    // إذا كان المتحكم موجود مسبقاً، لا نقوم بإعادة تهيئته
    if (videoControllers.containsKey(index)) return;

    // تعيين حالة التحميل
    loadingStates[index] = true.obs;
    errorStates[index] = false.obs;

    try {
      final videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(url),
        httpHeaders: {'User-Agent': 'flutter_video_player'},
      );

      videoPlayerController
          .initialize()
          .then((_) {
            // إنشاء متحكم Chewie بعد النجاح في تهيئة متحكم الفيديو
            final chewieController = ChewieController(
              videoPlayerController: videoPlayerController,
              autoPlay: true,
              looping: true,
              aspectRatio:
                  videoPlayerController.value.aspectRatio > 0
                      ? videoPlayerController.value.aspectRatio
                      : 16 / 9,
              allowMuting: true,
              // عرض أزرار التحكم (تشغيل/إيقاف)
              showControls: true,
              // تصغير أزرار التحكم ليناسب عرض السلايدر
              materialProgressColors: ChewieProgressColors(
                playedColor: Colors.red,
                handleColor: Colors.red,
                backgroundColor: Colors.grey.shade300,
                bufferedColor: Colors.grey.shade500,
              ),
              errorBuilder: (context, errorMessage) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error, color: Colors.white, size: 36),
                      SizedBox(height: 8),
                      Text(
                        "Unable to play video",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            );

            videoControllers[index] = chewieController;
            loadingStates[index]?.value = false;
            update();
          })
          .catchError((error) {
            print('Error initializing video controller: $error');
            loadingStates[index]?.value = false;
            errorStates[index]?.value = true;
            update();
          });
    } catch (e) {
      print('Exception creating video controller: $e');
      loadingStates[index]?.value = false;
      errorStates[index]?.value = true;
      update();
    }
  }

  // إيقاف وتشغيل الفيديو عند تغيير الصفحة
  void onPageChanged(int oldIndex, int newIndex) {
    // إيقاف الفيديو السابق
    if (videoControllers.containsKey(oldIndex)) {
      videoControllers[oldIndex]?.pause();
    }

    // تشغيل الفيديو الحالي
    if (videoControllers.containsKey(newIndex)) {
      videoControllers[newIndex]?.play();
    }
  }

  // التخلص من متحكمات الفيديو عند الخروج
  void disposeAll() {
    for (final controller in videoControllers.values) {
      if (controller != null) {
        controller.videoPlayerController.dispose();
        controller.dispose();
      }
    }
    videoControllers.clear();
    loadingStates.clear();
    errorStates.clear();
    mediaTypes.clear();
    mediaPaths.clear();
  }

  @override
  void onClose() {
    disposeAll();
    super.onClose();
  }

  // للتحقق مما إذا كان المحتوى صورة
  bool isImage(int index) {
    return mediaTypes[index]?.value.toLowerCase() == 'image';
  }

  // للحصول على مسار الوسائط
  String? getMediaPath(int index) {
    return mediaPaths[index]?.value;
  }

  // للتحقق من حالة التحميل
  bool isLoading(int index) {
    return loadingStates[index]?.value ?? false;
  }

  // للتحقق من حالة الخطأ
  bool hasError(int index) {
    return errorStates[index]?.value ?? false;
  }
}
