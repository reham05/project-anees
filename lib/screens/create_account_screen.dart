import 'package:anees/screens/signup_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';
import 'login_screen.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: Stack(
        children: [
          Positioned(
            bottom: 40.h,
            left: 40.w,
            child: SvgPicture.asset(
              'assets/images/Ellipse-12.svg',
              fit: BoxFit.fill,
              height: 60.h,
            ),
          ),
          Positioned(
            bottom: -10.h,
            right: 0.w,
            child: SvgPicture.asset(
              'assets/images/Ellipse-11.svg',
              fit: BoxFit.fill,
              height: 200.h,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          'assets/images/create-account.svg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 50.w,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                      child: Text(
                    "You need to create your account",
                    style: GoogleFonts.inter(
                        fontSize: 18.sp, fontWeight: FontWeight.w600),
                  )),
                  Center(
                      child: Text(
                    "so that your progress can be saved",
                    style: GoogleFonts.inter(
                        fontSize: 18.sp, fontWeight: FontWeight.w600),
                  )),
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                      child: Container(
                    height: 40.h,
                    width: 235.w,
                    decoration: BoxDecoration(
                      color: cGreen,
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ));
                        },
                        child: Text(
                          "Create Account",
                          style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: cWhite),
                        )),
                  )),
                  SizedBox(
                    height: 10.h,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Login',
                          style: GoogleFonts.inter(
                            color: cGreen2,
                            fontWeight: FontWeight.w400,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
