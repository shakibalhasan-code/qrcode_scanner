import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_inventory/app/bindings/initial_binding.dart';
import 'package:qr_code_inventory/app/utils/routes/app_pages.dart';

void main() async {
  // Ensure Flutter is initialized before anything else
  WidgetsFlutterBinding.ensureInitialized();
  // Then initialize dependencies
  InitialBinding().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Qr Code Inventory',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(
              fontSizeFactor: 1.sp,
              bodyColor: const Color(0xFF0D1F3C),
              displayColor: const Color(0xFF0D1F3C),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(color: Color(0xFF8A94A4)),
              labelStyle: TextStyle(color: Color(0xFF0D1F3C)),
            ),
          ),
          initialBinding: InitialBinding(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}