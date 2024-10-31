import 'package:anees/utils/colors.dart';
import 'package:anees/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class AccountConfirmationScreen extends StatelessWidget {
  final String email;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AccountConfirmationScreen({super.key, required this.email});

  Future<void> _resendVerificationEmail(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: cGreen,
            content: Text(
              'Verification email has been resent to $email',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: cWhite,
                fontWeight: FontWeight.bold,
              ),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageAsset(
              imagePath: "assets/images/confiramtion_email.png",
              color: cGreen,
              height: 150.h,
              width: 150.w,
            ),
            SizedBox(height: 10.h),
            Text(
              'Your account has been successfully created!',
              style: GoogleFonts.aclonica(
                  fontSize: 16.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              'Please check your email ($email) to verify your account.',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(cGreen)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(
                'Go to Login',
                style: GoogleFonts.inter(
                  color: cWhite,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            TextButton(
              onPressed: () => _resendVerificationEmail(context),
              child: Text(
                'Resend Verification Email',
                style: GoogleFonts.inter(
                  color: cGreen2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
