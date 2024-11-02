// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:anees/screens/forgot_password_screen.dart';
import 'package:anees/screens/home.dart';
import 'package:anees/screens/pick_screen.dart';
import 'package:anees/screens/signup_screen.dart';
import 'package:anees/screens/widgets/txtformfield.dart';
import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/auth_service.dart';
import '../utils/image_util.dart';
import 'upload_personal_image_screen.dart';
import 'user_role_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool obscurePassword = true;
  bool btnIsLoading = false;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    setState(() {
      btnIsLoading = true;
    });
    try {
      // ignore: unused_local_variable
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user?.emailVerified ?? false) {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        DocumentSnapshot doc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc['completedPickInterest'] == false) {
          Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) => const UploadPersonalImageScreen(),
              ));
        } else {
          Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ));
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Please verify your email before logging in',
                style: GoogleFonts.inter(
                  color: cWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              )),
        );
        setState(() {
          btnIsLoading = false;
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Email or password is incorrect',
              style: GoogleFonts.inter(
                color: cWhite,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            )),
      );
      setState(() {
        btnIsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: btnIsLoading,
      child: Scaffold(
        backgroundColor: cWhite,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                      Txtformfield(
                        controller: _email,
                        text: "Email address",
                        prefixIcon: Icons.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email cannot be empty.';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
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
                        controller: _password,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty.';
                          }
                          return null;
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
                            if (_formKey.currentState!.validate()) {
                              loginUser(_email.text.trim(), _password.text);
                            }
                          },
                          child: btnIsLoading
                              ? ImageAsset(
                                  imagePath: "assets/images/loading.gif",
                                  height: 50.h,
                                  width: 50.w,
                                )
                              : Text(
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
                            InkWell(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      content: Row(
                                        children: [
                                          SizedBox(
                                            height: 25.h,
                                            width: 25.w,
                                            child:
                                                const CircularProgressIndicator(
                                              color: cGreen,
                                            ),
                                          ),
                                          SizedBox(width: 20.w),
                                          Text(
                                            "Loading...",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                                final result =
                                    await _authService.signInWithTwitter();
                                if (result != null) {
                                  final User user = result['user'];
                                  final bool isNewUser = result['isNewUser'];

                                  if (isNewUser) {
                                    log("This is a new user: ${user.displayName}");
                                    Navigator.pushReplacement(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const UserRoleSelectionPage(),
                                        ));
                                  } else {
                                    log("This is an existing user: ${user.displayName}");
                                    String uid =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    DocumentSnapshot doc =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid)
                                            .get();

                                    if (doc['userType'] == null ||
                                        doc['userType'] == '') {
                                      Navigator.pushReplacement(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const UserRoleSelectionPage(),
                                          ));
                                    } else if (doc['completedPickInterest'] ==
                                        false) {
                                      Navigator.pushReplacement(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PickScreen(),
                                          ));
                                    } else {
                                      Navigator.pushReplacement(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Home()),
                                      );
                                    }
                                  }
                                } else {
                                  log("Login failed or was cancelled.");
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'An error occurred. Try again.',
                                          style: GoogleFonts.inter(
                                            color: cWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                          ),
                                        )),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: cGreen,
                                radius: 18.r,
                                child: FaIcon(
                                  FontAwesomeIcons.xTwitter,
                                  color: Colors.white,
                                  size: 15.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            InkWell(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      content: Row(
                                        children: [
                                          SizedBox(
                                            height: 25.h,
                                            width: 25.w,
                                            child:
                                                const CircularProgressIndicator(
                                              color: cGreen,
                                            ),
                                          ),
                                          SizedBox(width: 20.w),
                                          Text(
                                            "Loading...",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                                final result =
                                    await _authService.signInWithGoogle();
                                if (result != null) {
                                  final User user = result['user'];
                                  final bool isNewUser = result['isNewUser'];

                                  if (isNewUser) {
                                    log("This is a new user: ${user.displayName}");
                                    Navigator.pushReplacement(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const UserRoleSelectionPage(),
                                        ));
                                  } else {
                                    log("This is an existing user: ${user.displayName}");
                                    String uid =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    DocumentSnapshot doc =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid)
                                            .get();

                                    if (doc['userType'] == null ||
                                        doc['userType'] == '') {
                                      Navigator.pushReplacement(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const UserRoleSelectionPage(),
                                          ));
                                    } else if (doc['completedPickInterest'] ==
                                        false) {
                                      Navigator.pushReplacement(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PickScreen(),
                                          ));
                                    } else {
                                      Navigator.pushReplacement(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Home()),
                                      );
                                    }
                                  }
                                } else {
                                  log("Login failed or was cancelled.");
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'An error occurred. Try again.',
                                          style: GoogleFonts.inter(
                                            color: cWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                          ),
                                        )),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: cGreen,
                                radius: 18.r,
                                child: FaIcon(
                                  FontAwesomeIcons.google,
                                  color: Colors.white,
                                  size: 15.sp,
                                ),
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
          ),
        )),
      ),
    );
  }
}
