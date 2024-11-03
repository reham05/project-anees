// ignore_for_file: prefer_const_constructors, deprecated_member_use, unused_element, unused_import

import 'dart:developer';

import 'package:anees/Firebase/firestore.dart';
import 'package:anees/screens/comment_screen.dart';
import 'package:anees/screens/postdetails_screen.dart';
import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  // Map<String, dynamic> userData = {};

  // @override
  // void initState() {
  //   super.initState();
  //   getUserData();
  // }

  // Future<void> getUserData() async {
  //   try {
  //     final data = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .get();

  //     if (data.exists) {
  //       setState(() {
  //         userData = data.data() as Map<String, dynamic>;
  //       });
  //     } else {
  //       log("User data not found");
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }
  _getCommentsLength(String postId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      int commentCount = snapshot.docs.length;

      log('Number of comments: $commentCount');
      return commentCount.toString();
    } catch (e) {
      log('Error getting comments length: $e');
      return 0.toString();
    }
  }

// Function to create a dynamic link and share it
  Future<void> sharePostLink(String postId) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix:
            'https://aneesapp.page.link', // Replace with your dynamic link prefix
        link: Uri.parse('https://aneesapp.com/post/$postId'),
        androidParameters: AndroidParameters(
          packageName: 'com.example.anees', // Your app package name
          minimumVersion: 1,
        ),
        iosParameters: IOSParameters(
          bundleId: 'com.example.anees', // Your iOS app bundle ID
          minimumVersion: '1.0.1',
        ),
      );

      final Uri shortUrl =
          await FirebaseDynamicLinks.instance.buildLink(parameters);
      updateShareCount(postId);
      Share.share(shortUrl.toString());
    } catch (e) {
      log('Error creating dynamic link: $e');
    }
  }

  void updateShareCount(String postId) {
    // Update your Firestore logic here to increment share count
    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'share_count': FieldValue.increment(1),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cGreen4,
      appBar: AppBar(
        backgroundColor: cGreen4,
        title: Text(
          "Posts",
          style: GoogleFonts.aclonica(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("posts").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error"));
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No Posts are added.",
                      style: GoogleFonts.inter(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Map<String, dynamic> postMap = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailScreen(postId: postMap['postid']),
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
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  // height: 100.h,
                                  // width: 320.w,
                                  decoration: BoxDecoration(
                                      color: cGreen4,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                              backgroundImage: NetworkImage(
                                                  postMap['userImage'] ?? ''),
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
                                                        postMap['fullName'],
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ),
                                                  Text(postMap['createdAt'],
                                                      style: GoogleFonts.inter(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textDirection: TextDirection.rtl,
                                              postMap['des']),
                                        ),
                                        postMap['imagepost'] == ''
                                            ? const SizedBox.shrink()
                                            : SizedBox(
                                                height: 5.h,
                                              ),
                                        postMap['imagepost'] == ''
                                            ? const SizedBox.shrink()
                                            : Container(
                                                height: 150.h,
                                                // width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: cGreen,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            postMap[
                                                                'imagepost']),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                              ),
                                        postMap['imagepost'] == ''
                                            ? const SizedBox.shrink()
                                            : SizedBox(
                                                height: 5.h,
                                              ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Transform(
                                                    alignment: Alignment.center,
                                                    transform:
                                                        Matrix4.rotationY(3.14),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          sharePostLink(postMap[
                                                              'postid']);
                                                        },
                                                        icon: Icon(
                                                          Icons.reply,
                                                          color: Colors.black,
                                                          size: 23.sp,
                                                        ))),
                                                Text(postMap['share_count']
                                                    .toString()),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      // FirestoreMethod().deletePosts(
                                                      //     postMap: postMap);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                CommentScreen(
                                                              postId: postMap[
                                                                  'postid'],
                                                            ),
                                                          ));
                                                    },
                                                    icon: Icon(
                                                      Icons.comment_rounded,
                                                      color: Colors.black,
                                                      size: 23.sp,
                                                    )),
                                                Text(commentLength.toString()),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      FirestoreMethod().addLike(
                                                          postMap: postMap);
                                                    },
                                                    icon: Icon(
                                                      Icons.favorite,
                                                      color: postMap['likes']
                                                              .contains(
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)
                                                          ? Colors.red
                                                          : Colors.black,
                                                      size: 23.sp,
                                                    )),
                                                Text(postMap['likes']
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
                    itemCount: snapshot.data!.docs.length);
              },
            ),
          ],
        ),
      ),
    );
  }
}
