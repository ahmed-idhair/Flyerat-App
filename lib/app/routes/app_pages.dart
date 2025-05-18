import 'package:get/get.dart';

import '../../modules/categories_screen/view/categories_screen.dart';
import '../../modules/change_password/view/change_password.dart';
import '../../modules/comments_screen/view/comments_screen.dart';
import '../../modules/contact_us/view/contact_us.dart';
import '../../modules/edit_profile/view/edit_profile.dart';
import '../../modules/feedback/view/feedback.dart';
import '../../modules/flyer_details/view/flyer_details.dart';
import '../../modules/forgot_password/view/forgot_password.dart';
import '../../modules/help_support/view/help_support.dart';
import '../../modules/home/view/home.dart';
import '../../modules/lives_screen/view/lives_screen.dart';
import '../../modules/loyalty/view/loyalty_quiz_screen.dart';
import '../../modules/new_password/view/new_password.dart';
import '../../modules/notifications_screen/view/notifications_screen.dart';
import '../../modules/on_boardings/view/on_boardings_view.dart';
import '../../modules/page/view/page_view.dart';
import '../../modules/partner_details/view/partner_details.dart';
import '../../modules/products_screen/view/products_screen.dart';
import '../../modules/profile/view/profile.dart';
import '../../modules/select_location/view/location_permission_screen.dart';
import '../../modules/sign_in/view/sign_in.dart';
import '../../modules/sign_up/view/sign_up.dart';
import '../../modules/splash/view/splash.dart';
import '../../modules/verification_code/view/verification_code.dart';
import 'app_routes.dart';

final appPages = [
  GetPage(name: AppRoutes.splash, page: () => const Splash()),
  GetPage(name: AppRoutes.onBoarding, page: () => OnboardingView()),
  GetPage(name: AppRoutes.signIn, page: () => SignIn()),
  GetPage(name: AppRoutes.signUp, page: () => SignUp()),
  // GetPage(name: AppRoutes.serviceList, page: () => ServiceList()),
  // GetPage(name: AppRoutes.multiVerification, page: () => MultiVerification()),
  GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPassword()),
  GetPage(name: AppRoutes.newPassword, page: () => NewPassword()),
  GetPage(name: AppRoutes.verificationCode, page: () => VerificationCode()),
  GetPage(name: AppRoutes.pageView, page: () => PageView()),
  GetPage(name: AppRoutes.contactUs, page: () => ContactUs()),
  GetPage(name: AppRoutes.helpSupport, page: () => HelpSupport()),
  GetPage(name: AppRoutes.feedback, page: () => Feedback()),
  GetPage(name: AppRoutes.home, page: () => Home()),
  GetPage(name: AppRoutes.profile, page: () => Profile()),
  GetPage(name: AppRoutes.editProfile, page: () => EditProfile()),
  GetPage(name: AppRoutes.changePassword, page: () => ChangePassword()),
  GetPage(name: AppRoutes.partnerDetails, page: () => PartnerDetails()),
  GetPage(name: AppRoutes.flyerDetails, page: () => FlyerDetails()),
  GetPage(name: AppRoutes.commentsScreen, page: () => CommentsScreen()),
  GetPage(name: AppRoutes.livesScreen, page: () => LivesScreen()),
  GetPage(name: AppRoutes.categoriesScreen, page: () => CategoriesScreen()),
  GetPage(name: AppRoutes.productsScreen, page: () => ProductsScreen()),
  GetPage(name: AppRoutes.loyaltyQuizScreen, page: () => LoyaltyQuizScreen()),
  GetPage(
    name: AppRoutes.notificationsScreen,
    page: () => NotificationsScreen(),
  ),
  GetPage(
    name: AppRoutes.locationPermissionScreen,
    page: () => LocationPermissionScreen(),
  ),

  //
  // ///// Service Provider
  // GetPage(name: AppRoutes.spHome, page: () => SpHome()),
  // GetPage(name: AppRoutes.spProfileDisplay, page: () => SpProfileDisplay()),
  // GetPage(name: AppRoutes.spOrderDetails, page: () => SpOrderDetails()),
];
