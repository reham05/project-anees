// ignore_for_file: unused_import

import 'dart:developer';

import 'package:anees/Firebase/firestore.dart';
import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, this.postId, required this.postUserId});
  final String? postId;
  final String? postUserId;
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;
  TextEditingController comment = TextEditingController();
  Map<String, dynamic> userData = {};
  Future<void> _getCurrentUserData() async {
    try {
      final snapShot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = snapShot.data() as Map<String, dynamic>;
      setState(() {
        userData = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Comments",
          style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: cGreen,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId)
                        .collection('comments')
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: cGreen,
                            ),
                          ),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              "No comments are added.",
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            // ignore: unnecessary_cast
                            Map<String, dynamic> commentMap =
                                // ignore: unnecessary_cast
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;

                            return Container(
                              color: commentMap['uid'] ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? cGreen4
                                  : cWhite,
                              child: InkWell(
                                onLongPress: commentMap['uid'] ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? () {
                                        showMenu(
                                          color: Colors.grey[200],
                                          context: context,
                                          position: const RelativeRect.fromLTRB(
                                              100.0, 100.0, 0.0, 0.0),
                                          items: [
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Text("Delete Comment"),
                                            ),
                                          ],
                                        ).then((value) {
                                          if (value == 'delete') {
                                            FirestoreMethod().removeComment(
                                                commentMap: commentMap);
                                          }
                                        });
                                      }
                                    : null,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        commentMap['fullName'] ?? "",
                                        style: GoogleFonts.inter(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        DateFormat.MMMEd().format(
                                            commentMap['date'].toDate()),
                                        style: GoogleFonts.inter(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                  subtitle: Text(
                                    commentMap['comment'],
                                    style: GoogleFonts.inter(fontSize: 12.sp),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 20.r,
                                    backgroundImage: NetworkImage(
                                        commentMap['userImage'] ?? ''),
                                  ),
                                  // trailing: IconButton(
                                  //     onPressed: () {},
                                  //     icon: Icon(
                                  //       Icons.favorite,
                                  //       size: 20.sp,
                                  //     )),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          backgroundImage:
                              NetworkImage(userData['profile_picture_url']),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: TextField(
                            controller: comment,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      try {
                                        log("1");
                                        if (comment.text != '') {
                                          FirestoreMethod().addComment(
                                              comment: comment.text,
                                              fullName: userData['fullName'],
                                              userimage: userData[
                                                  'profile_picture_url'],
                                              uid: userData['uid'],
                                              postUserId: widget.postUserId,
                                              postid: widget.postId);
                                          log('2');
                                        }
                                        // log('2');
                                        setState(() {
                                          comment.text = '';
                                        });
                                      } on Exception catch (e) {
                                        log(e.toString());
                                      }
                                    },
                                    icon: const Icon(Icons.send)),
                                hintText: "add commment",
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: cGreen,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: cGreen4,
                                    ))),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
