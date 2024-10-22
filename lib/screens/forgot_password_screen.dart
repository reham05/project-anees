import 'package:anees/screens/widgets/txtformfield.dart';
import 'package:anees/utils/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: cWhite,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Forgot Password",
                            style: GoogleFonts.aclonica(
                              color: cGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                          child: Text(
                            "Enter your email address to get reset password link.",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 4,
                              fontStyle: FontStyle.italic,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          "  Email",
                          style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        const Txtformfield(
                          text: "Email address",
                          prefixIcon: Icons.email,
                        ),
                        SizedBox(
                          height: 20.h,
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
                            onPressed: () {},
                            child: Text(
                              "Get new password",
                              style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: cWhite),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40.h,
          right: 40.w,
          child: SvgPicture.asset(
            'assets/images/Ellipse-10.svg',
            fit: BoxFit.fill,
            height: 60.h,
          ),
        ),
        Positioned(
          bottom: -10.h,
          left: 0.w,
          child: SvgPicture.asset(
            'assets/images/Ellipse-09.svg',
            fit: BoxFit.fill,
            height: 200.h,
          ),
        ),
      ],
    );
  }
}
