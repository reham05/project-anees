import 'package:anees/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      appBar: AppBar(
        backgroundColor: cGreen,
        toolbarHeight: 70.h,
        title: Column(
          children: [
            SizedBox(
              height: 4.h,
            ),
            Text('About App',
                style: GoogleFonts.inter(
                  color: cWhite,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: cWhite,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anees is a dedicated application for book lovers, designed to cater to both Authors and Readers. '
              'Authors have the tools to create, publish, and share their literary works with a wider audience, allowing them to reach readers who appreciate their creations. '
              'Meanwhile, Readers can explore a vast library, discover new genres, and enjoy a diverse collection of books tailored to their interests. '
              'Anees provides a seamless experience, connecting authors and readers in a community driven by a love for literature and storytelling.',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Center(
              child: Text(
                'Version: 1.0.0',
                style: GoogleFonts.inter(fontSize: 14.sp, color: cGreen),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Center(
              child: Text(
                '© All rights reserved to Anees',
                style: GoogleFonts.inter(fontSize: 14.sp, color: cGreen),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
