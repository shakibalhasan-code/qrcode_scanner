import 'package:get/get.dart';
import 'package:qr_code_inventory/app/bindings/auth_binding.dart';
import 'package:qr_code_inventory/app/bindings/initial_binding.dart';
import 'package:qr_code_inventory/app/views/splash_screen.dart';
import 'package:qr_code_inventory/app/views/auth/changed_pass_view.dart';
import 'package:qr_code_inventory/app/views/auth/forget_screen.dart';
import 'package:qr_code_inventory/app/views/auth/otp_verify_screen.dart';
import 'package:qr_code_inventory/app/views/auth/reset_password_screen.dart';
import 'package:qr_code_inventory/app/views/auth/signin_screen.dart';
import 'package:qr_code_inventory/app/views/auth/signup_screen.dart';
import 'package:qr_code_inventory/app/views/main/dashboard/view/dashboard_view.dart';
import 'package:qr_code_inventory/app/views/main/dashboard/bindings/dashboard_binding.dart';
import 'package:qr_code_inventory/app/views/main/categories/category_list_screen.dart';
import 'package:qr_code_inventory/app/views/main/categories/bindings/category_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_ACCOUNT,
      page: () => CreateAccountScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(name: _Paths.OTP, page: () => OTPScreen(), binding: AuthBinding()),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => ResetPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD_CHANGED,
      page: () => PasswordChangedScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORIES,
      page: () => const CategoryListScreen(),
      binding: CategoryBinding(),
    ),
  ];
}
