import 'package:get/get.dart';

import 'ar_ps.dart';
import 'en_us.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': en,
    'ar_PS':ar,
  };

}