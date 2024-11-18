import 'package:anees/screens/widgets/txtformfield.dart';
import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/image_util.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool btnIsLoading = false;
  TextEditingController newPassword = TextEditingController();
  TextEditingController currentPassword = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool obscureCurrentPassword = true;
  bool loadingScreen = true;
  Map<String, dynamic>? userInfo;
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final snapShot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final userData = snapShot.data();
    setState(() {
      userInfo = userData;
      loadingScreen = false;
    });
  }

  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    setState(() {
      btnIsLoading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: currentPassword);

      await userCredential.user!.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password updated successfully',
            style: GoogleFonts.inter(
              color: cWhite,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: cGreen,
        ),
      );
      setState(() {
        btnIsLoading = false;
      });
    } on FirebaseAuthException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "The current password is incorrect",
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
      setState(() {
        btnIsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: cWhite,
            )),
        backgroundColor: cGreen,
        title: Text(
          "Change Password",
          style: GoogleFonts.aclonica(color: Colors.white, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: loadingScreen
          ? const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: cGreen,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "  Current Password:",
                        style: GoogleFonts.inter(
                            color: Colors.black, fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Txtformfield(
                        controller: currentPassword,
                        text: "Enter your current password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Current password cannot be empty';
                          }
                          return null;
                        },
                        suffixIcon: !obscureCurrentPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        obscureText: obscureCurrentPassword,
                        onPressed: () {
                          if (obscureCurrentPassword) {
                            setState(() {
                              obscureCurrentPassword = false;
                            });
                          } else {
                            setState(() {
                              obscureCurrentPassword = true;
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "  New Password:",
                        style: GoogleFonts.inter(
                            color: Colors.black, fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Txtformfield(
                        controller: newPassword,
                        text: "Enter your new password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your new password';
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
                        suffixIcon: !obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
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
                        height: 4.h,
                      ),
                      Text(
                        "  Confirm New Password:",
                        style: GoogleFonts.inter(
                            color: Colors.black, fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Txtformfield(
                        text: "Confirm your new password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your new password';
                          }
                          if (value != newPassword.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        obscureText: obscureConfirmPassword,
                        suffixIcon: !obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onPressed: () {
                          if (obscureConfirmPassword) {
                            setState(() {
                              obscureConfirmPassword = false;
                            });
                          } else {
                            setState(() {
                              obscureConfirmPassword = true;
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Center(
                          child: Container(
                        height: 40.h,
                        // width: 235.w,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cGreen,
                          borderRadius: BorderRadius.circular(36.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              changePassword(
                                  email: userInfo!['email'],
                                  currentPassword: currentPassword.text,
                                  newPassword: newPassword.text);
                            }
                          },
                          child: btnIsLoading
                              ? ImageAsset(
                                  imagePath: "assets/images/loading.gif",
                                  height: 50.h,
                                  width: 50.w,
                                )
                              : Text(
                                  "Change Password",
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
              ),
            ),
    );
  }
}
