import 'dart:developer';

import 'package:anees/screens/add_post_screen.dart';
import 'package:anees/screens/delete_posts_screen.dart';
import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import 'add_book.dart';
import 'delete_books_screen.dart';

class ShowOptions extends StatefulWidget {
  const ShowOptions({super.key});

  @override
  State<ShowOptions> createState() => _ShowOptionsState();
}

class _ShowOptionsState extends State<ShowOptions> {
  String? typeUserAccount = '';
  bool isLoading = true;

  void _getTypeUserAccount() async {
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final userData = snapShot.data();
      // log(userData!['userType'].toString());
      setState(() {
        typeUserAccount = userData!['userType'];
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
    _getTypeUserAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      appBar: AppBar(
        backgroundColor: cWhite,
        title: Center(
          child: Text("Create & Manage",
              style: GoogleFonts.aclonica(color: cGreen, fontSize: 18.sp)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Expanded(
              child: Center(
              child: CircularProgressIndicator(
                color: cGreen,
              ),
            ))
          : typeUserAccount == ''
              ? Expanded(
                  child: Center(
                    child: Text(
                      "An error occurred in the network",
                      style: GoogleFonts.inter(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.add,
                        color: cGreen,
                      ),
                      title: Text(
                        "Add Post",
                        style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            color: cGreen,
                            fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        // Logic to add a post
                        // ignore: avoid_print
                        print("Add Post");

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddPostScreen(),
                            ));
                      },
                    ),
                    typeUserAccount == "Author"
                        ? ListTile(
                            leading: const Icon(
                              Icons.book_outlined,
                              color: cGreen,
                            ),
                            title: Text(
                              "Add Book",
                              style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  color: cGreen,
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddBook(),
                                  ));
                            },
                          )
                        : const SizedBox.shrink(),
                    ListTile(
                      leading: const HugeIcon(
                        icon: HugeIcons.strokeRoundedListView,
                        color: cGreen,
                      ),
                      title: Text(
                        "View my posts / Delete Posts",
                        style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            color: cGreen,
                            fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeletePostsScreen(),
                            ));
                      },
                    ),
                    typeUserAccount == "Author"
                        ? ListTile(
                            leading: const HugeIcon(
                              icon: HugeIcons.strokeRoundedBook01,
                              color: cGreen,
                            ),
                            title: Text(
                              "View my Books / Delete Books",
                              style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  color: cGreen,
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DeleteBooksScreen(),
                                  ));
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
    );
  }
}
