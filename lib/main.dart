import 'package:anees/screens/author_profile_screen.dart';
import 'package:anees/screens/forgot_password_screen.dart';
import 'package:anees/screens/home_reader.dart';
import 'package:anees/screens/settings_screen.dart';
import 'package:anees/screens/signup_screen.dart';
import 'package:anees/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'screens/create_account_screen.dart';
import 'screens/home_screen_reader.dart';
import 'screens/pick_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Anees',
            theme: ThemeData(
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          );
        });
  }
}
