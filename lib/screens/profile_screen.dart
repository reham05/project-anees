import 'package:anees/screens/room_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart' as intl;

import '../Firebase/firestore.dart';
import '../utils/colors.dart';
import 'account_screen.dart';
import 'comment_screen.dart';
import 'postdetails_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key, required this.userId, required this.fromHome});
  final String? userId;
  final bool fromHome;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool pageLoading = false;
  int? index = 0;
  late int postCount = 0;
  late int followersCount = 0;
  late String fullName = '';
  late String userImage = '';
  late String userid = '';
  late List following;
  late bool infollowing;
  late String myName = '';
  late String myImage = '';
  Future<void> fetchCurrentUser() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    following = snapshot.data()!['following'];
    myName = snapshot.data()!['fullName'];
    myImage = snapshot.data()!['profile_picture_url'];
    infollowing = following.contains(widget.userId);
  }

  Future<void> fetchUserData() async {
    setState(() {
      pageLoading = true;
    });
    try {
      var snapPosts = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.userId)
          .get();
      var snapUsers = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      var userData = snapUsers.data();
      setState(() {
        postCount = snapPosts.docs.length;
        fullName = userData!['fullName'];
        userImage = userData['profile_picture_url'];
        userid = userData['uid'];
        followersCount = userData["followers"].length;
      });
      await fetchCurrentUser();
      setState(() {
        pageLoading = false;
      });
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred, please try again',
            style: GoogleFonts.inter(
              color: cWhite,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        pageLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    super.dispose();

    pageLoading = false;
    index = 0;
    int postCount = 0;
    int followersCount = 0;
    String fullName = '';
    String userImage = '';
    List following;
    bool infollowing;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return pageLoading
        ? const Scaffold(
            backgroundColor: cWhite,
            body: Center(
              child: CircularProgressIndicator(
                color: cGreen,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: cWhite,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/images/Ellipse-author-profile.svg',
                      fit: BoxFit.fill,
                    ),
                    Container(
                      color: cGreen4,
                      height: 30.h,
                      width: double.infinity,
                    ),

                    // Positioned(
                    //     child: SafeArea(
                    //   child: IconButton(
                    //       onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
                    // )),
                    Positioned(
                      left: 50.w,
                      right: 50.w,
                      top: 15.h,
                      child: SafeArea(
                        child: Column(
                          children: [
                            Container(
                              width: 120.w,
                              height: 120.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: cGreen,
                                  width: 5.0,
                                ),
                                // image: DecorationImage(
                                //     image: const AssetImage("assets/images/person.png"),
                                //     fit: BoxFit.fill,
                                //     scale: 3),
                              ),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 57.r,
                                  backgroundImage: NetworkImage(userImage),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              fullName,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                widget.fromHome ||
                                        FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            widget.userId
                                    ? const SizedBox.shrink()
                                    : SizedBox(
                                        width: 20.w,
                                      ),
                                SizedBox(
                                  width: widget.fromHome ||
                                          FirebaseAuth
                                                  .instance.currentUser!.uid ==
                                              widget.userId
                                      ? 150.w
                                      : 110.w,
                                  height: 30.h,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              infollowing ? cGreen3 : cGreen),
                                      onPressed: () {
                                        if (widget.userId !=
                                            FirebaseAuth
                                                .instance.currentUser!.uid) {
                                          if (infollowing == true) {
                                            setState(() {
                                              infollowing = false;
                                              followersCount -= 1;
                                            });
                                            FirestoreMethod().unfollowUser(
                                                userId: widget.userId);
                                            //unfollow
                                          } else {
                                            setState(() {
                                              infollowing = true;
                                            });

                                            FirestoreMethod().followUser(
                                                userId: widget.userId);
                                            followersCount += 1;
                                          }
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const AccountScreen(),
                                              ));
                                        }
                                      },
                                      child: Center(
                                          child: Text(
                                        widget.userId ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? "Edit Profile"
                                            : infollowing
                                                ? "unfollow"
                                                : "Follow",
                                        style: GoogleFonts.inter(
                                            color: Colors.white),
                                      ))),
                                ),
                                widget.fromHome ||
                                        FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            widget.userId
                                    ? const SizedBox.shrink()
                                    : InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RoomChatScreen(
                                                        fullName: fullName,
                                                        userImage: userImage,
                                                        uid: userid,
                                                        readmessage: true,
                                                      )));
                                        },
                                        child: HugeIcon(
                                          icon:
                                              HugeIcons.strokeRoundedMessage02,
                                          color: cGreen,
                                          size: 30.sp,
                                        ),
                                      )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    widget.fromHome == false
                        ? Positioned(
                            child: SafeArea(
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: cGreen,
                                )),
                          ))
                        : const SizedBox.shrink(),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Center(
                  child: SizedBox(
                    width: width / 1.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "26",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600, fontSize: 14.sp),
                            ),
                            Text(
                              "Book",
                              style: GoogleFonts.poly(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade500,
                                  fontSize: 14.sp),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              followersCount.toString(),
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600, fontSize: 14.sp),
                            ),
                            Text(
                              "Followers",
                              style: GoogleFonts.poly(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade500,
                                  fontSize: 14.sp),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              postCount.toString(),
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600, fontSize: 14.sp),
                            ),
                            Text(
                              "Posts",
                              style: GoogleFonts.poly(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade500,
                                  fontSize: 14.sp),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                      width: width / 1.4,
                      child: const Divider(
                        thickness: 2,
                      )),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Center(
                  child: SizedBox(
                    width: width / 1.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          child: Text(
                            "Author’s Books",
                            style: GoogleFonts.inter(
                                fontWeight: index == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13.sp),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          },
                          child: Text(
                            "Posts",
                            style: GoogleFonts.inter(
                                fontWeight: index == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13.sp),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                index == 0
                    ? Expanded(
                        child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.6,
                          ),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: cGreen4,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  Container(
                                    height: 135.h,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15)),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/demobook.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Center(
                                    child: Expanded(
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        'Arabistan orchards-1',
                                        style: GoogleFonts.inter(
                                            color: cGreen,
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ))
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Expanded(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: cGreen,
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(
                              "Error",
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp),
                              textAlign: TextAlign.center,
                            ));
                          }
                          if (snapshot.data!.docs.isEmpty) {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  "No Posts are added",
                                  style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.sp),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 2),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> postMap =
                                        // ignore: unnecessary_cast
                                        snapshot.data!.docs[index].data()
                                            as Map<String, dynamic>;

                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PostDetailScreen(
                                                      postId:
                                                          postMap['postid']),
                                            ));
                                      },
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(postMap['postid'])
                                              .collection('comments')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            int commentLength =
                                                snapshot.data?.docs.length ?? 0;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                // height: 100.h,
                                                // width: 320.w,
                                                decoration: BoxDecoration(
                                                    color: cGreen4,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
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
                                                                    postMap['userImage'] ??
                                                                        ''),
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                      postMap[
                                                                          'fullName'],
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
                                                                ),
                                                                Text(
                                                                    intl.DateFormat
                                                                            .MMMEd()
                                                                        .format(postMap['date']
                                                                            .toDate()),
                                                                    style: GoogleFonts.inter(
                                                                        fontSize: 12
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            postMap['des']),
                                                      ),
                                                      postMap['imagepost'] == ''
                                                          ? const SizedBox
                                                              .shrink()
                                                          : SizedBox(
                                                              height: 5.h,
                                                            ),
                                                      postMap['imagepost'] == ''
                                                          ? const SizedBox
                                                              .shrink()
                                                          : Container(
                                                              height: 150.h,
                                                              // width: double.infinity,
                                                              decoration: BoxDecoration(
                                                                  color: cGreen,
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                          postMap[
                                                                              'imagepost']),
                                                                      fit: BoxFit
                                                                          .cover),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                            ),
                                                      postMap['imagepost'] == ''
                                                          ? const SizedBox
                                                              .shrink()
                                                          : SizedBox(
                                                              height: 5.h,
                                                            ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Transform(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  transform: Matrix4
                                                                      .rotationY(
                                                                          3.14),
                                                                  child: IconButton(
                                                                      onPressed: () {
                                                                        // sharePostLink(
                                                                        //     postMap[
                                                                        //         'postid']);
                                                                      },
                                                                      icon: Icon(
                                                                        Icons
                                                                            .reply,
                                                                        color: Colors
                                                                            .black,
                                                                        size: 23
                                                                            .sp,
                                                                      ))),
                                                              Text(postMap[
                                                                      'share_count']
                                                                  .toString()),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    // FirestoreMethod().deletePosts(
                                                                    //     postMap: postMap);
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              CommentScreen(
                                                                            postId:
                                                                                postMap['postid'],
                                                                          ),
                                                                        ));
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .comment_rounded,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 23.sp,
                                                                  )),
                                                              Text(commentLength
                                                                  .toString()),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    FirestoreMethod().addLike(
                                                                        postMap:
                                                                            postMap,
                                                                        userFullName:
                                                                            myName,
                                                                        userImage:
                                                                            myImage);
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .favorite,
                                                                    color: postMap['likes'].contains(FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid)
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .black,
                                                                    size: 23.sp,
                                                                  )),
                                                              Text(postMap[
                                                                      'likes']
                                                                  .length
                                                                  .toString()),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    );
                                  },
                                  separatorBuilder: (context, index) => Divider(
                                        color: Colors.grey.shade400,
                                      ),
                                  itemCount: snapshot.data!.docs.length),
                            ),
                          );
                        }),
              ],
            ),
          );
  }
}
