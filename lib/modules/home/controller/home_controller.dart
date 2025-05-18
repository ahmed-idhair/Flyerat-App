import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers/app/widgets/common/app_bottom_sheet.dart';
import 'package:offers/modules/base_controller.dart';
import 'package:offers/modules/categories_screen/view/categories_screen.dart';
import 'package:offers/modules/home_page/view/home_page.dart';
import 'package:offers/modules/settings_page/view/settings_page.dart';

import '../../favorites_screen/view/favorites_screen.dart';

class HomeController extends BaseController {
  // Current selected index
  final selectedIndex = 0.obs; // Start with Wishlist selected
  // Change selected index
  void changeIndex(int index) {
    if (index == 2) {
      if (storage.isAuth()) {
        selectedIndex.value = index;
      } else {
        confirmBottomSheet();
      }
    } else {
      selectedIndex.value = index;
    }
  }

  List<Widget> screens = [
    HomePage(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsPage(),
  ];
}
