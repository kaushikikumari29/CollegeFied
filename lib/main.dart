import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/routes/app_pages.dart';
import 'package:collegefied/shared/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent background
    statusBarIconBrightness: Brightness.dark, // dark icons (for light bg)
    statusBarBrightness: Brightness.light, // for iOS
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CollegeFIed',
      theme: ThemeData.light(),
      initialRoute: SharedPrefs.getAuthToken() == null
          ? AppRoutes.welcome
          : AppRoutes.home,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
