import 'package:anees/screens/add_post_screen.dart';
import 'package:anees/screens/delete_posts_screen.dart';
import 'package:anees/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowOptions extends StatelessWidget {
  const ShowOptions({super.key});

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
      body: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.add,
              color: cGreen,
            ),
            title: Text(
              "Add Post",
              style: GoogleFonts.inter(
                  fontSize: 15.sp, color: cGreen, fontWeight: FontWeight.w500),
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
          ListTile(
            leading: const Icon(
              Icons.book,
              color: cGreen,
            ),
            title: Text(
              "Add Book",
              style: GoogleFonts.inter(
                  fontSize: 15.sp, color: cGreen, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              // // Logic to add a book
              // // ignore: avoid_print
              // print("Add Book");
              // Navigator.pop(context); // Close the bottom sheet
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.book,
              color: cGreen,
            ),
            title: Text(
              "View my posts / Delete Posts",
              style: GoogleFonts.inter(
                  fontSize: 15.sp, color: cGreen, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeletePostsScreen(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
