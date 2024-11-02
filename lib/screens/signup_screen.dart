import 'dart:developer';

import 'package:anees/screens/home.dart';
import 'package:anees/screens/pick_screen.dart';
import 'package:anees/screens/privacy_policy.dart';
import 'package:anees/screens/terms_conditions_screen.dart';
import 'package:anees/screens/user_role_selection_screen.dart';
import 'package:anees/utils/image_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/auth_service.dart';
import '../utils/colors.dart';
import 'account_confirmation_screen.dart';
import 'widgets/txtformfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isChecked = false;
  bool obscurePassword = true;
  bool obscureConfrimPassword = true;
  bool btnIsLoading = false;
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? _userType;
  // Function to handle sign-up
  Future<void> _signUp({
    required String fullName,
    required String email,
    required String password,
    required String userType,
  }) async {
    setState(() {
      btnIsLoading = true;
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user UID
      String uid = userCredential.user!.uid;

      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'createdAt': Timestamp.now(),
        // 'password': password,
        'userType': userType,
        'profile_picture_url': "not-image",
        "completedPickInterest": false
      });
      await userCredential.user?.sendEmailVerification();
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => AccountConfirmationScreen(
                    email: email,
                  )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'This email is already registered',
              style: GoogleFonts.inter(
                color: cWhite,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred, please try again',
              style: GoogleFonts.inter(
                color: cWhite,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                          Txtformfield(
                            controller: _fullName,
                            text: "Enter your full name",
                            prefixIcon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }

                              if (RegExp(r'\d').hasMatch(value)) {
                                return 'Full name must not contain numbers';
                              }
                              return null;
                            },
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
                          Txtformfield(
                            controller: _email,
                            text: "Email address",
                            prefixIcon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
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
                                      groupValue: _userType,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _userType = value;
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
                                      groupValue: _userType,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _userType = value;
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
                                return 'Please enter your password';
                              }

                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }

                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return 'Password must contain at least one uppercase letter';
                              }

                              if (!RegExp(r'[a-z]').hasMatch(value)) {
                                return 'Password must contain at least one lowercase letter';
                              }

                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return 'Password must contain at least one number';
                              }

                              if (!RegExp(r'[\W_]').hasMatch(value)) {
                                return 'Password must contain at least one special character';
                              }
                              return null;
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _password.text) {
                                return 'Passwords do not match';
                              }
                              return null;
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
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const TermsConditionsScreen()));
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
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PrivacyPolicyScreen()));
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_userType == null || _userType == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "You must specify whether you are an author or a reader",
                                          style: GoogleFonts.inter(
                                            color: cWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else if (_isChecked == false) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "You must agree to the Terms and Privacy Policy",
                                          style: GoogleFonts.inter(
                                            color: cWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    _signUp(
                                        fullName: _fullName.text.trim(),
                                        email: _email.text.trim(),
                                        password: _password.text,
                                        userType: _userType!);
                                  }
                                }
                              },
                              child: btnIsLoading
                                  ? ImageAsset(
                                      imagePath: "assets/images/loading.gif",
                                      height: 50.h,
                                      width: 50.w,
                                    )
                                  : Text(
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
                                      final bool isNewUser =
                                          result['isNewUser'];

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
                                        String uid = FirebaseAuth
                                            .instance.currentUser!.uid;
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
                                        } else if (doc[
                                                'completedPickInterest'] ==
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
                                                builder: (context) =>
                                                    const Home()),
                                          );
                                        }
                                      }
                                    } else {
                                      log("Login failed or was cancelled.");
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                      final bool isNewUser =
                                          result['isNewUser'];

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
                                        String uid = FirebaseAuth
                                            .instance.currentUser!.uid;
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
                                        } else if (doc[
                                                'completedPickInterest'] ==
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
                                                builder: (context) =>
                                                    const Home()),
                                          );
                                        }
                                      }
                                    } else {
                                      log("Login failed or was cancelled.");
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
