// ignore_for_file: collection_methods_unrelated_type

import 'package:anees/screens/eventdetails_screen.dart';
import 'package:anees/screens/postdetails_screen.dart';
import 'package:anees/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../data/models/notification_item.dart';
import '../utils/colors.dart';
import 'book_details_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, this.fromHomeScreen = true});
  final bool? fromHomeScreen;
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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("activitesNotifications")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notifications")
        .orderBy('date', descending: true)
        .get();

    List<Map<String, dynamic>> newNotifications = [];
    List<Map<String, dynamic>> pastNotifications = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      data['isNew'] = data['newNotification'] == true;
      data['notificationId'] = doc.id;

      if (data['isNew']) {
        newNotifications.add(data);
      } else {
        pastNotifications.add(data);
      }
    }

    return [...newNotifications, ...pastNotifications];
  }

  Future<void> updateNotificationStatus({required notificationId}) async {
    await FirebaseFirestore.instance
        .collection("activitesNotifications")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notifications")
        .doc(notificationId)
        .update({
      'newNotification': false,
    });
  }

  Future<void> updateeventsNotificationStatus({required notificationId}) async {
    await FirebaseFirestore.instance
        .collection("eventsNotifications")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notifications")
        .doc(notificationId)
        .update({
      'newNotification': false,
    });
  }

  Future<List<QueryDocumentSnapshot>> fetcheventsNotifications() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("eventsNotifications")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notifications")
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs;
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
                  )),
              widget.fromHomeScreen!
                  ? const SizedBox.shrink()
                  : Positioned(
                      top: 25.h,
                      left: 10.w,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: cGreen,
                          ))),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  'Events',
                  style: TextStyle(
                    color: _tabController.index == 0 ? cGreen : Colors.black,
                    fontWeight: _tabController.index == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
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
                    child: FutureBuilder(
                      future: fetcheventsNotifications(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: cGreen,
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No notifications found'),
                          );
                        }
                        var notifications = snapshot.data!;
                        return ListView.separated(
                            itemBuilder: (context, index) {
                              var notificationData = notifications[index];
                              updateeventsNotificationStatus(
                                  notificationId:
                                      notificationData['notificationId']);
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
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EventdetailsScreen(
                                                    eventdetails:
                                                        notificationData),
                                          ));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: notificationData[
                                                      'newNotification'] ==
                                                  true
                                              ? cGreen4
                                              : Colors.grey.shade200),
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
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                      notificationData[
                                                          'institutionImage'],
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
                                                      style:
                                                          DefaultTextStyle.of(
                                                                  context)
                                                              .style,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: notificationData[
                                                                  'institutionName'] +
                                                              " ",
                                                          style:
                                                              GoogleFonts.inter(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      13.sp),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              notificationData[
                                                                  'eventTitle'],
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      12.sp),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    timeago.format(
                                                        notificationData['date']
                                                            .toDate(),
                                                        locale: 'en_short'),
                                                    style: GoogleFonts.inter(
                                                        color: Colors.black,
                                                        fontSize: 12.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'Delete this notification',
                                                        style: TextStyle(
                                                            color: cGreen),
                                                      ),
                                                      content: const Text(
                                                          'Do you want to delete this notification?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () async {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "eventsNotifications")
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                                .collection(
                                                                    "notifications")
                                                                .doc(notificationData[
                                                                    'notificationId'])
                                                                .delete();
                                                            setState(() {
                                                              notifications
                                                                  .remove(
                                                                      index);
                                                            });

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color: cGreen),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon:
                                                  const Icon(Icons.more_horiz),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 5.h,
                                ),
                            itemCount: notifications.length);
                      },
                    ),
                  ),
                ),
                FutureBuilder(
                  future: fetchNotifications(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: cGreen,
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No notifications found'),
                      );
                    }

                    var notifications = snapshot.data!;
                    bool pastSectionShown = false;

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          var notificationData = notifications[index];
                          updateNotificationStatus(
                              notificationId:
                                  notificationData['notificationId']);

                          if (notificationData['isNew'] && index == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "New",
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                buildNotificationCard(
                                    notificationData, index, context),
                              ],
                            );
                          } else if (!notificationData['isNew'] &&
                              !pastSectionShown) {
                            pastSectionShown = true;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Past notifications",
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                buildNotificationCard(
                                    notificationData, index, context),
                              ],
                            );
                          } else {
                            return buildNotificationCard(
                                notificationData, index, context);
                          }
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 5.h),
                        itemCount: notifications.length,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationCard(
      Map<String, dynamic> notificationData, index, BuildContext context) {
    return InkWell(
      onTap: () {
        if (notificationData.containsKey('postid')) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PostDetailScreen(postId: notificationData['postid'])));
        } else if (notificationData.containsKey('bookid')) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookDetailsScreen(
                        book: notificationData['book'],
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                      userId: notificationData['uid'], fromHome: false)));
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: notificationData['isNew'] ? cGreen4 : Colors.grey.shade200,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundImage: NetworkImage(notificationData['userImage'] ??
                    "assets/images/person.png"),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: notificationData['fullName'] + " ",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                          TextSpan(
                            text: notificationData['notifiactionTitle'],
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timeago.format(notificationData['date'].toDate(),
                          locale: 'en_short'),
                      style: GoogleFonts.inter(
                          color: Colors.black, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Delete this notification',
                          style: TextStyle(color: cGreen),
                        ),
                        content: const Text(
                            'Do you want to delete this notification?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              FirebaseFirestore.instance
                                  .collection("activitesNotifications")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection("notifications")
                                  .doc(notificationData['notificationId'])
                                  .delete();
                              setState(() {
                                notifications.remove(index);
                              });

                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: cGreen),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
