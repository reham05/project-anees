//add anees bot

// ignore_for_file: unused_import

import 'package:anees/screens/about_app_screen.dart';
import 'package:anees/screens/about_book_screen.dart';
import 'package:anees/screens/account_confirmation_screen.dart';
import 'package:anees/screens/account_screen.dart';
import 'package:anees/screens/add_book.dart';
import 'package:anees/screens/change_password_screen.dart';
import 'package:anees/screens/chat_screen.dart';
import 'package:anees/screens/delete_books_screen.dart';
import 'package:anees/screens/delete_posts_screen.dart';
import 'package:anees/screens/forgot_password_screen.dart';
import 'package:anees/screens/home.dart';
import 'package:anees/screens/home_screen.dart';

import 'package:anees/screens/pick_screen.dart';
import 'package:anees/screens/posts_screen.dart';
import 'package:anees/screens/room_chat_screen.dart';
import 'package:anees/screens/upload_personal_image_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import 'screens/add_feedback_screen.dart';
import 'screens/add_post_screen.dart';
import 'screens/authors_screen.dart';
import 'screens/book_details_screen.dart';
import 'screens/comment_screen.dart';
import 'screens/postdetails_screen.dart';
import 'screens/privacy_policy.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/terms_conditions_screen.dart';
import 'screens/user_role_selection_screen.dart';
import 'screens/view_books_with_filter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

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
              debugShowCheckedModeBanner: false,
              title: 'Anees',
              theme: ThemeData(
                useMaterial3: true,
              ),
              home: const SplashScreen());
        });
  }
}
