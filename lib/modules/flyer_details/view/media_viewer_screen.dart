import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/common/app_network_image.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../core/models/home/media_data.dart';

class MediaViewerScreen extends StatefulWidget {
  final List<MediaData>? mediaList;
  final int initialIndex;
  final String? singleImageUrl;

  const MediaViewerScreen({
    super.key,
    this.mediaList,
    this.initialIndex = 0,
    this.singleImageUrl,
  });

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  Map<int, ChewieController?> _videoControllers = {};
  late List<MediaData> _effectiveMediaList;

  @override
  void initState() {
    super.initState();

    _effectiveMediaList = _createEffectiveMediaList();

    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    // Initialize video controllers for any videos that are initially visible
    _initVideoController(_currentIndex);
    // Also initialize controllers for adjacent pages
    if (_currentIndex > 0) {
      _initVideoController(_currentIndex - 1);
    }
    if (_currentIndex < _effectiveMediaList.length - 1) {
      _initVideoController(_currentIndex + 1);
    }
  }

  // Helper method to create the effective media list
  List<MediaData> _createEffectiveMediaList() {
    if (widget.singleImageUrl != null) {
      // If a single image URL is provided, create a media list with just that image
      return [MediaData(type: 'image', path: widget.singleImageUrl)];
    } else {
      // Otherwise use the provided media list
      return widget.mediaList!;
    }
  }

  void _initVideoController(int index) {
    if (index < 0 || index >= _effectiveMediaList.length) return;

    final media = _effectiveMediaList[index];
    if (media.type?.toLowerCase() == 'video' && media.path != null) {
      try {
        // Add error handling for video initialization
        final videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(media.path!),
          httpHeaders: {
            // Add any necessary headers for your API
            'User-Agent': 'flutter_video_player',
          },
        );

        videoPlayerController
            .initialize()
            .then((_) {
              if (mounted) {
                final chewieController = ChewieController(
                  videoPlayerController: videoPlayerController,
                  autoPlay: index == _currentIndex,
                  looping: false,
                  showControls: true,
                  // Use 16:9 as fallback if aspectRatio is not available or invalid
                  aspectRatio:
                      videoPlayerController.value.aspectRatio > 0
                          ? videoPlayerController.value.aspectRatio
                          : 16 / 9,
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
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                );

                setState(() {
                  _videoControllers[index] = chewieController;
                });
              }
            })
            .catchError((error) {
              print('Error initializing video controller: $error');
              // Handle video initialization errors
              setState(() {
                // Mark this controller as null so we show the error UI
                _videoControllers[index] = null;
              });
            });
      } catch (e) {
        print('Exception creating video controller: $e');
      }
    }
  }

  void _disposeVideoController(int index) {
    final controller = _videoControllers[index];
    if (controller != null) {
      controller.videoPlayerController.dispose();
      controller.dispose();
      _videoControllers.remove(index);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      // Pause the video on the previous page
      if (_videoControllers[_currentIndex] != null) {
        _videoControllers[_currentIndex]!.pause();
      }

      _currentIndex = index;

      // Play the video on the current page
      if (_videoControllers[_currentIndex] != null) {
        _videoControllers[_currentIndex]!.play();
      }

      // Initialize controller for the next page if needed
      if (index < _effectiveMediaList.length - 1) {
        _initVideoController(index + 1);
      }

      // Initialize controller for the previous page if needed
      if (index > 0) {
        _initVideoController(index - 1);
      }

      // Dispose controllers that are no longer needed
      for (final controllerIndex in _videoControllers.keys.toList()) {
        if ((controllerIndex < index - 1) || (controllerIndex > index + 1)) {
          _disposeVideoController(controllerIndex);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();

    // Dispose all video controllers
    for (final controller in _videoControllers.values) {
      if (controller != null) {
        controller.videoPlayerController.dispose();
        controller.dispose();
      }
    }
    _videoControllers.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title:
            _effectiveMediaList.length > 1
                ? "${_currentIndex + 1}/${_effectiveMediaList.length}"
                : _effectiveMediaList[0].type?.toLowerCase() == 'video'
                ? LangKeys.videoViewer.tr
                : LangKeys.imageViewer.tr,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Media viewer
            PageView.builder(
              controller: _pageController,
              itemCount: _effectiveMediaList.length,
              physics:
                  _effectiveMediaList.length > 1
                      ? const PageScrollPhysics() // Normal scrolling for multiple items
                      : const NeverScrollableScrollPhysics(),
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final media = _effectiveMediaList[index];
                if (media.type?.toLowerCase() == 'video') {
                  final videoController = _videoControllers[index];
                  if (videoController == null) {
                    // Show error message when controller failed to initialize
                    return AppLoadingView();
                    // return Center(
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(
                    //         Icons.error_outline,
                    //         color: Colors.white,
                    //         size: 48,
                    //       ),
                    //       SizedBox(height: 16),
                    //       Text(
                    //         "Unable to play video",
                    //         style: TextStyle(color: Colors.white, fontSize: 16),
                    //       ),
                    //       SizedBox(height: 8),
                    //       Text(
                    //         "The video format may be unsupported or the URL is incorrect.",
                    //         style: TextStyle(
                    //           color: Colors.white70,
                    //           fontSize: 14,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //       SizedBox(height: 24),
                    //       ElevatedButton(
                    //         onPressed: () => _initVideoController(index),
                    //         child: Text("Retry"),
                    //         style: ElevatedButton.styleFrom(
                    //           backgroundColor: Colors.white,
                    //           foregroundColor: Colors.black,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // );
                  }
                  return Center(child: Chewie(controller: videoController));
                } else {
                  // Image
                  return Center(
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: AppNetworkImage(
                        imageUrl: media.path ?? "",
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 0,
                      ),
                    ),
                  );
                }
              },
            ),
            // Navigation buttons
            if (_effectiveMediaList.length > 1)
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous button
                    if (_currentIndex > 0)
                      _buildNavigationButton(
                        icon: Icons.arrow_back_ios,
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),

                    // Spacer
                    if (_currentIndex > 0 &&
                        _currentIndex < _effectiveMediaList.length - 1)
                      const Spacer(),

                    // Next button
                    if (_currentIndex < _effectiveMediaList.length - 1)
                      _buildNavigationButton(
                        icon: Icons.arrow_forward_ios,
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(12.r),
        backgroundColor: Colors.white.withOpacity(0.3),
      ),
      child: Icon(icon, color: Colors.white, size: 24.r),
    );
  }
}
