// ignore_for_file: unnecessary_cast

import 'dart:developer';

import 'package:anees/screens/room_chat_screen.dart';
import 'package:anees/screens/widgets/txtformfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int currentIndex = 0;
  List<String> filters = ["All", "Unread", "Sent"];
  String searchQuery = '';
  String formatTimeWithRelativeDate(DateTime dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    left: 132.w,
                    right: 40.w,
                    top: 40.h,
                    child: SafeArea(
                        child: Text(
                      "Messages",
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
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Txtformfield(
                text: "Search for chat...",
                suffixIcon: Icons.search_rounded,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40.h,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                            });
                            log(currentIndex.toString());
                          },
                          child: Container(
                            height: 40.h,
                            width: 120.w,
                            decoration: currentIndex == index
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF77B0AA),
                                        Color(0xFF003C43)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  )
                                : BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade500,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                  child: Text(
                                filters[index],
                                style: GoogleFonts.poly(
                                  color: currentIndex == index
                                      ? cWhite
                                      : Colors.grey.shade500,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                ),
                              )),
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          width: 10.w,
                        ),
                    itemCount: filters.length),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .where('participants',
                          arrayContains: FirebaseAuth.instance.currentUser!.uid)
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(
                          child: Center(
                              child: CircularProgressIndicator(
                        color: cGreen,
                      )));
                    }
                    if (snapshot.hasError) {
                      log(snapshot.toString());
                      return const Center(child: Text("Error"));
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "You did not have any conversation.",
                          style: GoogleFonts.inter(
                              color: Colors.black, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    String currentId = FirebaseAuth.instance.currentUser!.uid;

                    var filteredChats = snapshot.data!.docs.where((doc) {
                      String fullName = currentId == doc['senderId']
                          ? doc['reciverName']
                          : doc['senderName'];
                      return fullName
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                    }).toList();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            // Map<String, dynamic> chatMap =
                            //     snapshot.data!.docs[index].data()
                            //         as Map<String, dynamic>;
                            var chatMap = filteredChats[index].data()
                                as Map<String, dynamic>;
                            String currentId =
                                FirebaseAuth.instance.currentUser!.uid;

                            String fullName = currentId == chatMap['senderId']
                                ? chatMap['reciverName']
                                : chatMap['senderName'];

                            String userImage = currentId == chatMap['senderId']
                                ? chatMap['reciverImage']
                                : chatMap['senderImage'];

                            String uid = currentId == chatMap['senderId']
                                ? chatMap['reciverId']
                                : chatMap['senderId'];

                            return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(chatMap['chatroomid'])
                                    .collection('messages')
                                    .orderBy('date', descending: true)
                                    .limit(1)
                                    .snapshots(),
                                builder: (context, messageSnapshot) {
                                  if (messageSnapshot.hasData &&
                                      messageSnapshot.data!.docs.isNotEmpty) {
                                    var lastMessageData =
                                        messageSnapshot.data!.docs.first;

                                    var lastMessage =
                                        lastMessageData['message'] ?? '';
                                    var readmessage =
                                        lastMessageData['readmessage'] ?? false;
                                    var senderid =
                                        lastMessageData['senderid'] ?? '';
                                    var messageTime = lastMessageData['date'] ??
                                        Timestamp.now();
                                    if (messageSnapshot.hasData &&
                                        messageSnapshot.data!.docs.isNotEmpty) {
                                      var lastMessageData =
                                          messageSnapshot.data!.docs.first;

                                      var lastMessage =
                                          lastMessageData['message'] ?? '';
                                      var readmessage =
                                          lastMessageData['readmessage'] ??
                                              false;
                                      var senderid =
                                          lastMessageData['senderid'] ?? '';
                                      var messageTime =
                                          lastMessageData['date'] ??
                                              Timestamp.now();
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                    if (currentIndex == 0) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RoomChatScreen(
                                                  fullName: fullName,
                                                  userImage: userImage,
                                                  uid: uid,
                                                  readmessage:
                                                      readmessage == true &&
                                                          FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid !=
                                                              senderid,
                                                ),
                                              ));
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              // height: 80.h,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: cGreen4,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 22.r,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            userImage,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(fullName,
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts.inter(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Text(
                                                                      formatTimeWithRelativeDate(
                                                                          messageTime
                                                                              .toDate()),
                                                                      style: GoogleFonts
                                                                          .inter(
                                                                        fontSize:
                                                                            12.sp,
                                                                      )),
                                                                ],
                                                              ),
                                                              Text(
                                                                lastMessage,
                                                                style: GoogleFonts
                                                                    .inter(
                                                                        fontSize:
                                                                            13.sp),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            readmessage == false &&
                                                    FirebaseAuth.instance
                                                            .currentUser!.uid !=
                                                        senderid
                                                ? Positioned(
                                                    bottom: 12.h,
                                                    right: 10.w,
                                                    child: CircleAvatar(
                                                      backgroundColor: cGreen,
                                                      radius: 5.r,
                                                    ))
                                                : const SizedBox.shrink()
                                          ],
                                        ),
                                      );
                                    } else if (currentIndex == 1) {
                                      if (readmessage == false &&
                                          senderid !=
                                              FirebaseAuth
                                                  .instance.currentUser!.uid) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RoomChatScreen(
                                                    fullName: fullName,
                                                    userImage: userImage,
                                                    uid: uid,
                                                    readmessage: readmessage ==
                                                            true &&
                                                        FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid !=
                                                            senderid,
                                                  ),
                                                ));
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                // height: 80.h,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: cGreen4,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 22.r,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              userImage,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        fullName,
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: GoogleFonts.inter(
                                                                            fontSize:
                                                                                14.sp,
                                                                            fontWeight: FontWeight.bold)),
                                                                    Text(
                                                                        DateFormat.jm().format(messageTime
                                                                            .toDate()),
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          fontSize:
                                                                              12.sp,
                                                                        )),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  lastMessage,
                                                                  style: GoogleFonts.inter(
                                                                      fontSize:
                                                                          13.sp),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              readmessage == false &&
                                                      FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid !=
                                                          senderid
                                                  ? Positioned(
                                                      bottom: 12.h,
                                                      right: 10.w,
                                                      child: CircleAvatar(
                                                        backgroundColor: cGreen,
                                                        radius: 5.r,
                                                      ))
                                                  : const SizedBox.shrink()
                                            ],
                                          ),
                                        );
                                      }
                                    } else if (currentIndex == 2) {
                                      if (senderid ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RoomChatScreen(
                                                    fullName: fullName,
                                                    userImage: userImage,
                                                    uid: uid,
                                                    readmessage: readmessage ==
                                                            true &&
                                                        FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid !=
                                                            senderid,
                                                  ),
                                                ));
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                // height: 80.h,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: cGreen4,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 22.r,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              userImage,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        fullName,
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: GoogleFonts.inter(
                                                                            fontSize:
                                                                                14.sp,
                                                                            fontWeight: FontWeight.bold)),
                                                                    Text(
                                                                        DateFormat.jm().format(messageTime
                                                                            .toDate()),
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          fontSize:
                                                                              12.sp,
                                                                        )),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  lastMessage,
                                                                  style: GoogleFonts.inter(
                                                                      fontSize:
                                                                          13.sp),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              readmessage == false &&
                                                      FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid !=
                                                          senderid
                                                  ? Positioned(
                                                      bottom: 12.h,
                                                      right: 10.w,
                                                      child: CircleAvatar(
                                                        backgroundColor: cGreen,
                                                        radius: 5.r,
                                                      ))
                                                  : const SizedBox.shrink()
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                    return const SizedBox.shrink();
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                });
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 5.h,
                              ),
                          itemCount: filteredChats.length),
                    );
                  }),
            )
          ],
        ));
  }
}
