import 'package:anees/screens/forgot_password_screen.dart';
import 'package:anees/screens/home_reader.dart';
import 'package:anees/screens/signup_screen.dart';
import 'package:anees/screens/widgets/txtformfield.dart';
import 'package:anees/utils/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
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
                "Log In",
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
                "Enter your credential to Login.",
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
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(height: 20.h),
                  Center(
                      child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()));
                    },
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.inter(
                          color: cGreen2,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  )),
                  SizedBox(height: 25.h),
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
                        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>const HomeReader()));
                      },
                      child: Text(
                        "Log In",
                        style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: cWhite),
                      ),
                    ),
                  )),
                  SizedBox(
                    height: 15.h,
                  ),
                  Center(
                    child: Text(
                      "Log In with",
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
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Don’t have an account? ',
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Create account',
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
                                            const SignupScreen()));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
