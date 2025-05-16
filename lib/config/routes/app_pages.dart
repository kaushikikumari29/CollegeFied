import 'package:collegefied/modules/auth/bindings/auth_binding.dart';
import 'package:collegefied/modules/auth/views/login_page.dart';
import 'package:collegefied/modules/auth/views/sign_up_page.dart';
import 'package:collegefied/modules/auth/views/welcome_page.dart';
import 'package:collegefied/modules/auth/views/verify_email_page.dart';
import 'package:collegefied/modules/auth/views/forgot_password_page.dart';
import 'package:collegefied/modules/auth/views/otp_page.dart';
import 'package:collegefied/modules/auth/views/reset_password_page.dart';
import 'package:collegefied/modules/category/views/category_view.dart';
import 'package:collegefied/modules/chat/views/charts_list.dart';

import 'package:collegefied/modules/chat/views/manage_request_page.dart';
import 'package:collegefied/modules/chat/views/chat_page.dart';
import 'package:collegefied/modules/history/binding/history_binding.dart';
import 'package:collegefied/modules/history/views/history_page.dart';
import 'package:collegefied/modules/home/views/home_page.dart';
import 'package:collegefied/modules/product/binding/product_binding.dart';
import 'package:collegefied/modules/product/views/create_product_page.dart';
import 'package:collegefied/modules/product/views/edit_product_page.dart';
import 'package:collegefied/modules/product/views/my_products_page.dart';
import 'package:collegefied/modules/product/views/product_detail_page.dart';
import 'package:collegefied/modules/profile/bindings/profile_binding.dart';
import 'package:collegefied/modules/profile/views/edit_profile_page.dart';
import 'package:collegefied/modules/profile/views/profile_page.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.welcome,
      page: () => WelcomePage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignUpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.verifyEmail,
      page: () => EmailVerificationPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => OtpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => ResetPasswordPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => EditProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.createProduct,
      page: () => CreateProductPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.updateProduct,
      page: () => EditProductPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.myProductPage,
      page: () => MyProductPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => ProductDetailPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => ChatPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.manageRequest,
      page: () => ManageRequestPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.chatList,
      page: () => ChartsList(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => HistoryPage(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.categoryProducts,
      page: () => CategoryPage(
          category:
              Get.arguments), // <-- This expects a string in Get.arguments
    ),
  ];
}
