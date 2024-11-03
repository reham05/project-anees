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
              print("Add Post");
              Navigator.pop(context); // Close the bottom sheet
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
              // Logic to add a book
              print("Add Book");
              Navigator.pop(context); // Close the bottom sheet
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
              // Logic to add a book
              print("Add Book");
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
        ],
      ),
    );
  }
}
