import 'package:anees/screens/author_profile_screen.dart';
import 'package:anees/screens/chat_screen.dart';
import 'package:anees/screens/home_screen_reader.dart';
import 'package:anees/utils/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/image_util.dart';
import 'notification_screen.dart';

const pages = [
  HomeScreenReader(),
  ChatScreen(),
  Text("Add"),
  NotificationScreen(),
  AuthorProfileScreen(),
];

class HomeReader extends StatefulWidget {
  const HomeReader({super.key});

  @override
  State<HomeReader> createState() => _HomeReaderState();
}

class _HomeReaderState extends State<HomeReader> {
  int? globalIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: globalIndex == 0 ? Colors.black : Colors.white,
          ),
          SvgPicture.asset(
            'assets/images/Chats.svg',
            width: 40.w,
            height: 40.h,
            color: globalIndex == 1 ? Colors.black : Colors.white,
          ),
          SvgPicture.asset(
            'assets/images/Add.svg',
            width: 28.w,
            height: 28.h,
            color: globalIndex == 2 ? Colors.black : Colors.white,
          ),
          SvgPicture.asset(
            'assets/images/Notification-bell.svg',
            width: 32.w,
            height: 32.h,
            color: globalIndex == 3 ? Colors.black : Colors.white,
          ),
          SvgPicture.asset(
            'assets/images/User.svg',
            width: 30.w,
            height: 30.h,
            color: globalIndex == 4 ? Colors.black : Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            globalIndex = index;
          });
        },
      ),
      body: pages[globalIndex!],
    );
  }
}
