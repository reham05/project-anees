import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';
import 'widgets/txtformfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? _selectedOption;
  bool _isChecked = false;
  bool obscurePassword = true;
  bool obscureConfrimPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cWhite,
        body: SafeArea(
          child: SingleChildScrollView(
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
                Center(
                  child: Text(
                    "Sign Up",
                    style: GoogleFonts.aclonica(
                      color: cGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.sp,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "Enter your details to create account.",
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
                  height: 10.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "  Name",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      const Txtformfield(
                        text: "Enter your full name",
                        prefixIcon: Icons.person,
                      ),
                      SizedBox(
                        height: 5.h,
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
                        height: 5.h,
                      ),
                      Text(
                        "  You are..",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Radio<String>(
                                  activeColor: cGreen3,
                                  value: 'Author',
                                  groupValue: _selectedOption,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedOption = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Author',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'Reader',
                                  activeColor: cGreen3,
                                  groupValue: _selectedOption,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedOption = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Reader',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "  Password",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Txtformfield(
                        text: "Enter your password",
                        prefixIcon: Icons.person,
                        suffixIcon: obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        obscureText: obscurePassword,
                        onPressed: () {
                          if (obscurePassword) {
                            setState(() {
                              obscurePassword = false;
                            });
                          } else {
                            setState(() {
                              obscurePassword = true;
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "  Confirm password",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Txtformfield(
                        text: "Confirm Password",
                        prefixIcon: Icons.email,
                        suffixIcon: obscureConfrimPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        obscureText: obscureConfrimPassword,
                        onPressed: () {
                          if (obscureConfrimPassword) {
                            setState(() {
                              obscureConfrimPassword = false;
                            });
                          } else {
                            setState(() {
                              obscureConfrimPassword = true;
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            activeColor: cGreen3,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'I agree to ',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms',
                                    style: GoogleFonts.inter(
                                        color: cGreen2,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // print("Terms clicked");
                                      },
                                  ),
                                  TextSpan(
                                    text: ' and ',
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: GoogleFonts.inter(
                                        color: cGreen2,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // print("Privacy Policy clicked");
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
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
                            "Sign Up",
                            style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: cWhite),
                          ),
                        ),
                      )),
                      SizedBox(
                        height: 5.h,
                      ),
                      Center(
                        child: Text(
                          "Sign Up with",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: cGreen,
                              radius: 18.r,
                              child: FaIcon(
                                FontAwesomeIcons.xTwitter,
                                color: Colors.white,
                                size: 15.sp,
                              ),
                            ),
                            SizedBox(width: 20.w),
                            CircleAvatar(
                              backgroundColor: cGreen,
                              radius: 18.r,
                              child: FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                                size: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
