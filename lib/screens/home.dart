import 'package:anees/screens/posts_screen.dart';
import 'package:anees/screens/profile_screen.dart';
import 'package:anees/screens/chat_screen.dart';
import 'package:anees/screens/home_screen.dart';
import 'package:anees/screens/show_options_screen.dart';
import 'package:anees/utils/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'notification_screen.dart';

const pages = [
  HomeScreen(),
  ChatScreen(),
  PostsScreen(),
  ShowOptions(),
  NotificationScreen(),
  AuthorProfileScreen(),
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? globalIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: cWhite,
          buttonBackgroundColor: cGreen4,
          color: cGreen,
          height: 55.h,
          items: <Widget>[
            SvgPicture.asset(
              'assets/images/Home.svg',
              width: 30.w,
              height: 30.h,
              // ignore: deprecated_member_use
              color: globalIndex == 0 ? Colors.black : Colors.white,
            ),
            SvgPicture.asset(
              'assets/images/Chats.svg',
              width: 40.w,
              height: 40.h,
              // ignore: deprecated_member_use
              color: globalIndex == 1 ? Colors.black : Colors.white,
            ),
            Icon(
              Icons.article_outlined,
              color: globalIndex == 2 ? Colors.black : Colors.white,
              size: 28.sp,
            ),
            SvgPicture.asset(
              'assets/images/Add.svg',
              width: 28.w,
              height: 28.h,
              // ignore: deprecated_member_use
              color: globalIndex == 3 ? Colors.black : Colors.white,
            ),
            SvgPicture.asset(
              'assets/images/Notification-bell.svg',
              width: 32.w,
              height: 32.h,
              // ignore: deprecated_member_use
              color: globalIndex == 4 ? Colors.black : Colors.white,
            ),
            SvgPicture.asset(
              'assets/images/User.svg',
              width: 30.w,
              height: 30.h,
              // ignore: deprecated_member_use
              color: globalIndex == 5 ? Colors.black : Colors.white,
            ),
          ],
          onTap: (index) {
            setState(() {
              globalIndex = index;
            });
          },
        ),
        body: pages[globalIndex!],
      ),
    );
  }
}

