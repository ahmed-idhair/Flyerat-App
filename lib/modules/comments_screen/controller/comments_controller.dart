import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:offers/core/models/home/flyer.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../app/translations/lang_keys.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/comments/comment.dart';
import '../../../core/models/comments/comments.dart';

class CommentsController extends BaseController {
  final RxBool isLoading = false.obs;
  final RxList<Comment> comments = <Comment>[].obs;
  final TextEditingController commentController = TextEditingController();

  final PagingController<int, Comment> pagingController = PagingController(
    firstPageKey: 1,
  );
  final int _pageSize = 10;

  Flyer? flyer;

  @override
  void onInit() {
    super.onInit();
    flyer = Get.arguments['flyer'];
    pagingController.addPageRequestListener((pageKey) {
      fetchData(pageKey);
    });
  }

  Future<void> fetchData(int pageKey) async {
    try {
      Map<String, dynamic> body = {'page': pageKey};
      final result = await httpService
          .request(
            url: "${ApiConstant.partnerFlyers}/${flyer?.id}/comments",
            method: Method.GET,
            params: body,
          )
          .catchError((onError) => pagingController.error = onError);
      if (result != null) {
        var resp = ApiResponse.fromJsonModel(result.data, Comments.fromJson);
        final list = resp.data!.comments!;
        final isLastPage = list.length < _pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(list);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(list, nextPageKey);
        }
      } else {
        pagingController.error = LangKeys.anErrorFetchingData.tr;
      }
    } finally {
      // pagingController.error = LangKeys.anErrorFetchingData.tr;
    }
  }

  Future<void> addFlyerComment() async {
    try {
      // Show loading indicator
      // isLoading(true);
      final String commentText = commentController.text;
      if (commentText.isEmpty) return;

      EasyLoading.show();
      Map<String, dynamic> body = {'comment': commentText};

      final result = await httpService.request(
        url: "${ApiConstant.partnerFlyers}/${flyer?.id}/comment",
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var resp = ApiResponse<void>.fromJson(result.data);
        if (resp.isSuccess) {
          commentController.clear();
          pagingController.refresh();
        }
      }
    } finally {
      // Hide loading indicator
      // isLoading(false);
      EasyLoading.dismiss();
      update(['updateDetails']);
    }
  }
}
