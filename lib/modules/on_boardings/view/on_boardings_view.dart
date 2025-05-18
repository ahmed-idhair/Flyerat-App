import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/common/app_empty_state.dart';
import 'package:offers/app/widgets/common/app_error_widget.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/modules/on_boardings/controller/on_boardings_controller.dart';
import 'package:offers/modules/on_boardings/view/widget/item_on_boarding.dart';

class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});

  OnBoardingsController controller = Get.put(OnBoardingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AppLoadingView());
        }
        if (controller.items.isEmpty) {
          return Center(child: AppEmptyState(message: LangKeys.noData.tr));
        }
        return PageView.builder(
          controller: controller.pageController,
          itemCount: controller.items.length,
          onPageChanged: controller.onPageChanged,
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return ItemOnBoarding(
              title: item.title ?? "",
              description: item.description ?? "",
              imageUrl: item.image ?? "",
              currentIndex: index,
              totalPages: controller.items.length,
              isLastPage: index == controller.items.length - 1,
              onNext: controller.nextPage,
              onSkip: controller.skipOnboarding,
            );
          },
        );
      }),
    );
  }
}
