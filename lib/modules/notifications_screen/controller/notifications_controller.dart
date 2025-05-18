import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:offers/app/translations/lang_keys.dart';
import 'package:offers/core/models/lives/lives_data.dart';
import 'package:offers/core/models/lives/older.dart';
import 'package:offers/core/models/notifications/notification_older.dart';
import 'package:offers/modules/base_controller.dart';

import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/notifications/notifications_data.dart';

enum NotificationTab { all, read, unread }

class NotificationsController extends BaseController {
  final RxBool isInitialLoading = true.obs;
  final RxInt totalLives = 0.obs;
  final PagingController<int, NotificationOlder> pagingController =
      PagingController(firstPageKey: 1);

  // Page size for pagination
  final int _pageSize = 10;

  // Selected filter tab
  final Rx<NotificationTab> selectedTab = NotificationTab.all.obs;

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      _fetchLivesPage(pageKey);
    });
  }

  Future<void> _fetchLivesPage(int pageKey) async {
    try {
      if (pageKey == 1) {
        isInitialLoading(true);
      }
      Map<String, dynamic> body = {'page': pageKey};
      if (selectedTab.value == NotificationTab.read) {
        body['type'] = 'read';
      } else if (selectedTab.value == NotificationTab.unread) {
        body['type'] = 'unread';
      }
      final result = await httpService
          .request(
            url: ApiConstant.notifications,
            method: Method.GET,
            params: body,
          )
          .catchError((onError) {
            pagingController.error = onError;
            return null;
          });

      if (result == null) {
        // Handle the case where result is null (error was caught)
        if (!pagingController.error.toString().contains('Error')) {
          pagingController.error = LangKeys.notInternetConnection.tr;
        }
        return;
      }
      var response = ApiResponse.fromJsonModel(
        result.data,
        NotificationsData.fromJson,
      );
      if (response.isSuccess == true && response.data != null) {
        final livesData = response.data!.notifications;
        final pagination = response.data!.pagination;

        // Update total lives count
        totalLives.value = pagination?.total ?? 0;

        // Convert the grouped data into sections
        List<NotificationOlder> sections = [];

        // Add today section if it exists and this is the first page
        if (pageKey == 1 &&
            livesData?.today != null &&
            livesData!.today!.isNotEmpty) {
          sections.add(
            NotificationOlder(date: LangKeys.today.tr, items: livesData.today!),
          );
        }

        // Add yesterday section if it exists and this is the first page
        if (pageKey == 1 &&
            livesData?.yesterday != null &&
            livesData!.yesterday!.isNotEmpty) {
          sections.add(
            NotificationOlder(
              date: LangKeys.yesterday.tr,
              items: livesData.yesterday!,
            ),
          );
        }

        // Add older sections
        if (livesData?.older != null) {
          sections.addAll(
            livesData!.older!
                .map(
                  (dateGroup) => NotificationOlder(
                    date: dateGroup.date,
                    items: dateGroup.items,
                  ),
                )
                .toList(),
          );
        }

        // Determine if this is the last page
        final isLastPage = pagination!.currentPage! >= pagination.lastPage!;
        if (isLastPage) {
          pagingController.appendLastPage(sections);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(sections, nextPageKey);
        }
      } else {
        pagingController.error = response.message ?? 'Failed to load lives';
      }
    } catch (e) {
      pagingController.error = 'An error occurred: $e';
      print('Error fetching lives: $e');
    } finally {
      isInitialLoading(false);
    }
  }

  // Set the selected tab
  void setTab(NotificationTab tab) {
    if (selectedTab.value != tab) {
      selectedTab.value = tab;
      pagingController.refresh();
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
