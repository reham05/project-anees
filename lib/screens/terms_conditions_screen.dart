import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      appBar: AppBar(
        toolbarHeight: 70.h,
        backgroundColor: cGreen,
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
              'Terms and Conditions',
              style: GoogleFonts.inter(
                color: cWhite,
                fontSize: 18.sp,
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
              'Introduction',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Welcome to the Anees Application! By using this app, you agree to comply with the terms and conditions outlined here. Please read them carefully.',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'No Payment Processes',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Please note that there are no payment processes within the Anees Application. All services and features are provided free of charge to users. No financial information or payment details will be requested by the application.',
                  style: GoogleFonts.inter(fontSize: 13.sp),
                ),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'Intellectual Property Rights',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'All content within the application, including text, images, and logos, is the intellectual property of the Anees Application. Copying or using any content without prior permission is prohibited.',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'Registration Privacy',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Anees is committed to protecting your privacy. No personal data collected during registration will be used for commercial purposes or shared with third parties.',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'Third-Party Links',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'The application may contain links to external sites. We are not responsible for the content of these sites or their privacy practices.',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: cGreen,
            collapsedIconColor: Colors.grey,
            title: Text(
              'Modification of Terms and Conditions',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'We reserve the right to modify these terms and conditions at any time. Changes will be reviewed on this page, and by continuing to use the application, you agree to the modified terms.',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                  ),
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
                  'If you have any questions regarding these terms or need assistance, please contact us via email at: anees.cs100@gmail.com',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
