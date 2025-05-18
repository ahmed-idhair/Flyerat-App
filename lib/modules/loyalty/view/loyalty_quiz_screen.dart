// views/loyalty_quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:offers/app/config/app_theme.dart';
import 'package:offers/app/extensions/color.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/utils/app_utils.dart';
import 'package:offers/app/widgets/app_bar/custom_app_bar.dart';
import 'package:offers/app/widgets/buttons/app_button.dart';
import 'package:offers/app/widgets/common/app_empty_state.dart';
import 'package:offers/app/widgets/common/app_loading_view.dart';
import 'package:offers/app/widgets/forms/app_custom_text.dart';
import 'package:offers/modules/loyalty/controller/loyalty_quiz_controller.dart';

import '../../../core/models/competition/option.dart';
import '../../../core/models/competition/question.dart';

class LoyaltyQuizScreen extends StatelessWidget {
  LoyaltyQuizScreen({super.key});

  final LoyaltyQuizController controller = Get.put(LoyaltyQuizController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.loyalty.tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AppLoadingView());
        }
        if (controller.competition.value.questions == null ||
            controller.competition.value.questions!.isEmpty) {
          return Center(
            child: AppEmptyState(message: LangKeys.noQuizAvailable.tr),
          );
        }
        return _buildQuizContent();
      }),
    );
  }

  Widget _buildQuizContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          10.verticalSpace,
          _buildPointsCard(),
          22.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [..._buildQuestions()],
              ),
            ),
          ),

          SizedBox(height: 24.h),
          _buildSubmitButton(),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      // width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
      decoration: BoxDecoration(
        // color: Color(0xFFE25B3C),
        gradient: LinearGradient(
          colors: [HexColor("F04F32"), HexColor("F04F32"), HexColor("FFCCBB")],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCustomText(
                  text: LangKeys.loyaltyPoints.tr,
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          AppCustomText(
                            text:
                                "${controller.competition.value.allowedPoints}",
                            fontSize: 38.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(width: 4.w),
                          AppCustomText(
                            text: "Pts",
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      AppUtils.getIconPath("ic_gift"),
                      width: 60.w,
                      height: 60.h,
                    ),
                  ],
                ),
                6.verticalSpace,
                AppCustomText(
                  text: LangKeys.answerQuestionsToWin.tr,
                  fontSize: 15.sp,
                  textAlign: TextAlign.center,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQuestions() {
    List<Widget> questionWidgets = [];

    if (controller.competition.value.questions == null) return [];

    for (int i = 0; i < controller.competition.value.questions!.length; i++) {
      Question question = controller.competition.value.questions![i];

      questionWidgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 22.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCustomText(
                text: question.question ?? "",
                fontSize: 16.sp,
                color: HexColor("000B12"),
                fontWeight: FontWeight.w500,
              ),
              16.verticalSpace,
              if (question.options != null) ..._buildOptions(i, question),
            ],
          ),
        ),
      );
    }

    return questionWidgets;
  }

  List<Widget> _buildOptions(int questionIndex, Question question) {
    List<Widget> optionWidgets = [];

    for (Option option in question.options!) {
      bool isSelected = question.selectedOptionId == option.id;
      optionWidgets.add(
        // Obx(() {
        GestureDetector(
          onTap: () {
            controller.selectOption(questionIndex, option.id!);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 14.h),
            child: Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey,
                      width: 2.w,
                    ),
                    color: isSelected ? Colors.white : Colors.white,
                  ),
                  child:
                      isSelected
                          ? Icon(
                            Icons.circle,
                            size: 15.r,
                            color: AppTheme.primaryColor,
                          )
                          : null,
                ),
                8.horizontalSpace,
                Expanded(
                  child: AppCustomText(
                    text: option.option ?? "",
                    fontSize: 14.sp,
                    color: HexColor("2C2C2E"),
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        // }),
      );
    }

    return optionWidgets;
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      return AppButton(
        text: LangKeys.submitAnswers.tr,
        isLoading: controller.isSubmitting.value,
        onPressed: () => controller.submitAnswers(),
      );
    });
  }
}
