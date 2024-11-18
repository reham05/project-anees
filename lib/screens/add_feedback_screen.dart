import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Firebase/firestore.dart';
import '../utils/colors.dart';

class AddFeedbackScreen extends StatefulWidget {
  const AddFeedbackScreen({super.key, this.bookid, this.bookUserid, this.book});
  final String? bookid;
  final String? bookUserid;
  final Map<String, dynamic>? book;
  @override
  State<AddFeedbackScreen> createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends State<AddFeedbackScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;
  TextEditingController feedback = TextEditingController();
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
          "Feedbacks",
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
                        .collection('books')
                        .doc(widget.bookid)
                        .collection('feedbacks')
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
                              "No Feedbacks are added.",
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
                            Map<String, dynamic> feedbackMap =
                                // ignore: unnecessary_cast
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;

                            return Container(
                              color: feedbackMap['uid'] ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? cGreen4
                                  : cWhite,
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      feedbackMap['fullName'] ?? "",
                                      style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      DateFormat.MMMEd()
                                          .format(feedbackMap['date'].toDate()),
                                      style: GoogleFonts.inter(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                subtitle: Text(
                                  feedbackMap['feedback'],
                                  style: GoogleFonts.inter(fontSize: 12.sp),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: cGreen2,
                                  radius: 20.r,
                                  backgroundImage: NetworkImage(
                                      feedbackMap['userImage'] ?? ''),
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
                          backgroundColor: cGreen2,
                          radius: 25.r,
                          backgroundImage:
                              NetworkImage(userData['profile_picture_url']),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: TextField(
                            controller: feedback,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      try {
                                        log("1");
                                        if (feedback.text != '') {
                                          FirestoreMethod().addFeedBacks(
                                              feedback: feedback.text,
                                              fullName: userData['fullName'],
                                              userimage: userData[
                                                  'profile_picture_url'],
                                              uid: userData['uid'],
                                              bookAuthorId: widget.bookUserid,
                                              bookid: widget.bookid,
                                              book: widget.book);
                                          log('2');
                                        }
                                        // log('2');
                                        setState(() {
                                          feedback.text = '';
                                        });
                                      } on Exception catch (e) {
                                        log(e.toString());
                                      }
                                    },
                                    icon: const Icon(Icons.send,
                                        color: Colors.black)),
                                hintText: "add Feedback",
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
