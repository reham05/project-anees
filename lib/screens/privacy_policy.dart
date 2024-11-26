import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      appBar: AppBar(
        backgroundColor: cGreen,
        toolbarHeight: 70.h,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: cWhite,
            size: 18.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          children: [
            SizedBox(
              height: 4.h,
            ),
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontFamily: "Nizar",
                color: cWhite,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'Information We Collect',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'We collect personal information such as full name, and email address when you register for the application. We may also collect non-personal information, such as device and operating system data.',
                  style: GoogleFonts.inter(fontSize: 13.sp),
                ),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'How We Use Your Information',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'We use your information to improve our services, enhance your user experience, and communicate with you about updates or offers.',
                  style: GoogleFonts.inter(fontSize: 13.sp),
                ),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'Information Protection',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'We take appropriate security measures to protect your personal information from unauthorized access, use, or disclosure.',
                  style: GoogleFonts.inter(fontSize: 13.sp),
                ),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'Information Sharing',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'We do not sell, trade, or share your personal information with any third party, except as outlined in this policy.',
                  style: GoogleFonts.inter(fontSize: 13.sp),
                ),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'Your Rights',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'You have the right to access your personal information and request corrections or deletions. Please contact us if you wish to exercise these rights.',
                  style: GoogleFonts.inter(fontSize: 13.sp),
                ),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'Changes to the Privacy Policy',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'We reserve the right to update this privacy policy and will notify you of any changes by posting the updated version in the application.',
                  style: GoogleFonts.inter(fontSize: 13.sp),
                ),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'Contact Us',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'If you have any questions about this privacy policy, please contact us at: anees.cs100@gmail.com',
                  style: GoogleFonts.inter(fontSize: 13.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
