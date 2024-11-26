import 'dart:developer';

import 'package:anees/screens/book_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class AboutBookScreen extends StatefulWidget {
  const AboutBookScreen({super.key, this.book});
  final Map<String, dynamic>? book;

  @override
  State<AboutBookScreen> createState() => _AboutBookScreenState();
}

class _AboutBookScreenState extends State<AboutBookScreen> {
  bool loadingPage = true;
  late String typeUser;
  bool inShelf = false;
  void getUserData() async {
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (snapShot.data()!['userType'] == "Reader") {
        //reader
        final snapShotBooks = await FirebaseFirestore.instance
            .collection("bookshelf")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("books")
            .where('bookid', isEqualTo: widget.book!['bookid'])
            .get();
        log(snapShotBooks.docs.length.toString());
        if (snapShotBooks.docs.isNotEmpty) {
          setState(() {
            inShelf = true;
          });
        }
      }
      setState(() {
        typeUser = snapShot.data()!['userType'];
        loadingPage = false;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cGreen4,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        actions: [
          loadingPage == false
              ? typeUser == "Reader" // reader
                  ? IconButton(
                      onPressed: () async {
                        try {
                          final bookDoc = await FirebaseFirestore.instance
                              .collection("bookshelf")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("books")
                              .doc(widget.book!['bookid'])
                              .get();

                          if (bookDoc.exists) {
                            await FirebaseFirestore.instance
                                .collection("bookshelf")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("books")
                                .doc(widget.book!['bookid'])
                                .delete();
                            setState(() {
                              inShelf = false;
                            });
                          } else {
                            await FirebaseFirestore.instance
                                .collection("bookshelf")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("books")
                                .doc(widget.book!['bookid'])
                                .set({'bookid': widget.book!['bookid']});
                            setState(() {
                              inShelf = true;
                            });
                          }
                        } on Exception catch (e) {
                          log(e.toString());
                        }
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: inShelf ? Colors.red : Colors.black,
                      ))
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
        ],
      ),
      backgroundColor: loadingPage ? cGreen4 : cWhite,
      body: loadingPage
          ? const Center(
              child: CircularProgressIndicator(
                color: cGreen,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: cGreen4,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Center(
                            child: Container(
                                height: 200.h,
                                width: 150.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            widget.book!['urlBookCover'])))),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            widget.book!['title'],
                            style: GoogleFonts.inter(
                                color: cGreen, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.book!['authorName'],
                            style: GoogleFonts.inter(
                                color: cGreen, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextButton(
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(cGreen),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookDetailsScreen(
                                        book: widget.book,
                                      ),
                                    ));
                              },
                              child: Text(
                                "Feedbacks",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500, color: cWhite),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20.h,
                  width: double.infinity,
                  color: cWhite,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: cGreen,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description:",
                              style: GoogleFonts.inter(
                                  color: cWhite,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.book!['description'],
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                  color: cWhite,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w200),
                            ),
                            const Divider(
                              color: cWhite,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Page: ",
                                  style: GoogleFonts.inter(
                                      color: cWhite,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${widget.book!['numOfPages']} pages",
                                  style: GoogleFonts.inter(
                                      color: cWhite,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w200),
                                ),
                              ],
                            ),
                            const Divider(
                              color: cWhite,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Written: ",
                                  style: GoogleFonts.inter(
                                      color: cWhite,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.book!['written'],
                                  style: GoogleFonts.inter(
                                      color: cWhite,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w200),
                                ),
                              ],
                            ),
                            const Divider(
                              color: cWhite,
                            ),
                            Text(
                              "Bookstore Address: ",
                              style: GoogleFonts.inter(
                                  color: cWhite,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.book!['bookstoreAddress'],
                              style: GoogleFonts.inter(
                                  color: cWhite,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w200),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
