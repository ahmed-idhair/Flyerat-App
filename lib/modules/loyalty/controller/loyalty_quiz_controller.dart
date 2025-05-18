import 'package:get/get.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/app/widgets/common/app_bottom_sheet.dart';
import 'package:offers/core/api/api_constant.dart';
import 'package:offers/core/api/api_response.dart';
import 'package:offers/core/api/http_service.dart';
import 'package:offers/modules/base_controller.dart';
import 'package:offers/app/widgets/feedback/app_toast.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/models/competition/competition.dart';
import '../../../core/models/competition/question.dart';

class LoyaltyQuizController extends BaseController {
  final RxBool isLoading = false.obs;
  final Rx<Competition> competition = Competition().obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCompetition();
  }

  Future<void> getCompetition() async {
    try {
      isLoading(true);
      final result = await httpService.request(
        url: "${ApiConstant.competition}/1",
        method: Method.GET,
      );

      if (result != null) {
        var response = ApiResponse.fromJsonModel<Competition>(
          result.data,
          Competition.fromJson,
        );
        if (response.isSuccess && response.data != null) {
          Competition competitionResponse = response.data!;
          competition.value = competitionResponse;
        } else {
          AppToast.error(response.message);
        }
      }
    } catch (e) {
      AppToast.error("Failed to load competition");
    } finally {
      isLoading(false);
    }
  }

  void selectOption(int questionIndex, int optionId) {
    if (competition.value.questions != null &&
        questionIndex < competition.value.questions!.length) {
      competition.value.questions![questionIndex].selectedOptionId = optionId;
      competition.refresh();
    }
  }

  bool areAllQuestionsAnswered() {
    if (competition.value.questions == null) return false;
    return competition.value.questions!.every((question) {
      return question.selectedOptionId != null;
    });
  }

  Future<void> submitAnswers() async {
    if (!areAllQuestionsAnswered()) {
      showErrorBottomSheet(LangKeys.answerQuestionsToWin.tr);
      return;
    }
    try {
      isSubmitting(true);
      Map<String, dynamic> formData = {};
      if (competition.value.questions != null) {
        for (int i = 0; i < competition.value.questions!.length; i++) {
          Question question = competition.value.questions![i];
          if (question.selectedOptionId != null) {
            formData['answers[$i][question_id]'] = question.id.toString();
            formData['answers[$i][option_id]'] =
                question.selectedOptionId.toString();
          }
        }
      }

      final result = await httpService.request(
        url: "${ApiConstant.competition}/1/answer",
        method: Method.POST,
        params: formData,
        contentType: 'application/x-www-form-urlencoded',
      );
      if (result != null) {
        var response = ApiResponse.fromJson(result.data);
        if (response.isSuccess) {
          showSuccessBottomSheet(
            response.message,
            textBtn: LangKeys.home.tr,
            onClick: () {
              Get.offAllNamed(AppRoutes.home);
            },
          );
        } else {
          AppToast.error(response.message);
        }
      }
    } catch (e) {
      showErrorBottomSheet("Failed to submit answers: ${e.toString()}");
      print("Error submitting answers: $e");
    } finally {
      isSubmitting(false);
    }
  }
}
