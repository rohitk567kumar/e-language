import 'package:e_language/constant/app-constant.dart';
import 'package:e_language/user_auth/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: TextTheme(
            displayLarge: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: getResponsiveFontSize(context, 0.065),
            ),
            displayMedium: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: getResponsiveFontSize(context, 0.038),
            ),
            displaySmall: TextStyle(
              color: AppColors.textColor,
              fontSize: getResponsiveFontSize(context, 0.03),
            ),
          ),
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColors.backgroundColor,
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: AppColors.backgroundColor,
              elevation: 0),
          primarySwatch: Colors.green,
          primaryColor: AppColors.primaryColor),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey,
        scaffoldBackgroundColor: Colors.grey.shade700,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: getResponsiveFontSize(context, 0.10),
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: getResponsiveFontSize(context, 0.08),
          ),
          displaySmall: TextStyle(
            color: Colors.white,
            fontSize: getResponsiveFontSize(context, 0.05),
          ),
        ),
      ),
      home: 
      const SplashScreen(),
      //const MyBottomBar(),
      builder: EasyLoading.init(),
    );
  }
}
