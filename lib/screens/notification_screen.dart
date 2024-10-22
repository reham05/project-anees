import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/notification_item.dart';
import '../utils/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<NotificationItem> notifications = [
    NotificationItem("SSASCASC", 'New Notification 1', true),
    NotificationItem("SSASCASC", 'New Notification 2', true),
    NotificationItem("SSASCASC", 'Past Notification 1', false),
    NotificationItem("SSASCASC", 'Past Notification 2', false),
    NotificationItem("SSASCASC", 'New Notification 3', true),
    NotificationItem("SSASCASC", 'Past Notification 3', false),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // عدد التبويبات
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newNotifications = notifications.where((item) => item.isNew).toList();
    final pastNotifications =
        notifications.where((item) => !item.isNew).toList();
    return Scaffold(
      backgroundColor: cWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              SvgPicture.asset(
                'assets/images/Ellipse-chat.svg',
                fit: BoxFit.fill,
              ),
              Positioned(
                  left: 120.w,
                  right: 40.w,
                  top: 45.h,
                  child: SafeArea(
                      child: Text(
                    "Notifications",
                    style: GoogleFonts.aclonica(
                        fontWeight: FontWeight.bold,
                        color: cGreen,
                        fontSize: 18.sp),
                  ))),
              Positioned(
                  left: 0.w,
                  top: 60.h,
                  child: SvgPicture.asset(
                    "assets/images/Ellipse-001.svg",
                    fit: BoxFit.fill,
                  )),
              Positioned(
                  left: 50.w,
                  top: 95.h,
                  child: SvgPicture.asset(
                    "assets/images/Ellipse-002.svg",
                    fit: BoxFit.fill,
                  )),
              Positioned(
                  left: 120.w,
                  top: 0.h,
                  child: SafeArea(
                    child: SvgPicture.asset(
                      "assets/images/Ellipse-003.svg",
                      fit: BoxFit.fill,
                    ),
                  )),
              Positioned(
                  right: 80.w,
                  top: 0.h,
                  child: SafeArea(
                    child: SvgPicture.asset(
                      "assets/images/Ellipse-004.svg",
                      fit: BoxFit.fill,
                    ),
                  )),
              Positioned(
                  right: 0.w,
                  top: 0.h,
                  child: SafeArea(
                    child: SvgPicture.asset(
                      "assets/images/Ellipse-005.svg",
                      fit: BoxFit.fill,
                    ),
                  ))
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          TabBar(
            controller: _tabController, // ربط الـ TabBar بالـ TabController
            tabs: [
              Tab(
                child: Text(
                  'Events',
                  style: TextStyle(
                    color: _tabController.index == 0
                        ? cGreen
                        : Colors.black, // تغيير اللون عند النقر
                    fontWeight: _tabController.index == 0
                        ? FontWeight.bold
                        : FontWeight.normal, // تغيير سمك الخط
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Activities',
                  style: TextStyle(
                    color: _tabController.index == 1 ? cGreen : Colors.black,
                    fontWeight: _tabController.index == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],

            indicatorSize: TabBarIndicatorSize.tab,
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: cGreen,
                  width: 2.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                index == 0
                                    ? Text(
                                        "New",
                                        style: GoogleFonts.inter(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : const SizedBox.shrink(),
                                index == 0
                                    ? SizedBox(
                                        height: 5.h,
                                      )
                                    : const SizedBox.shrink(),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey.shade200),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 60.h,
                                          width: 60.w,
                                          decoration: BoxDecoration(
                                              color: cGreen,
                                              image: const DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                  "assets/images/demo-ministry.png",
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          "Ministry of Culture ",
                                                      style: GoogleFonts.inter(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13.sp),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "is holding a new event",
                                                      style: GoogleFonts.inter(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.black,
                                                          fontSize: 12.sp),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "3 h",
                                                style: GoogleFonts.inter(
                                                    color: Colors.black,
                                                    fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.more_horiz))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 5.h,
                            ),
                        itemCount: 10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      if (index < newNotifications.length) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index == 0
                                ? Text(
                                    "New",
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const SizedBox.shrink(),
                            index == 0
                                ? SizedBox(
                                    height: 5.h,
                                  )
                                : const SizedBox.shrink(),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade300),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 25.r,
                                      backgroundImage: AssetImage(
                                          "assets/images/person.png"),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: "Osamah Almuslim ",
                                                  style: GoogleFonts.inter(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13.sp),
                                                ),
                                                TextSpan(
                                                  text: "posted a new post",
                                                  style: GoogleFonts.inter(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.black,
                                                      fontSize: 12.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "3 h",
                                            style: GoogleFonts.inter(
                                                color: Colors.black,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.more_horiz))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        final pastIndex = index - newNotifications.length;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index == newNotifications.length
                                ? Text(
                                    "Past notifications",
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const SizedBox.shrink(),
                            index == newNotifications.length
                                ? SizedBox(
                                    height: 5.h,
                                  )
                                : const SizedBox.shrink(),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade200),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 25.r,
                                      backgroundImage: AssetImage(
                                          "assets/images/person.png"),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: "Osamah Almuslim ",
                                                  style: GoogleFonts.inter(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13.sp),
                                                ),
                                                TextSpan(
                                                  text: "liked your post",
                                                  style: GoogleFonts.inter(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.black,
                                                      fontSize: 12.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "3 h",
                                            style: GoogleFonts.inter(
                                                color: Colors.black,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.more_horiz))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 5.h),
                    itemCount:
                        newNotifications.length + pastNotifications.length,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
