import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';
import '../utils/image_util.dart';
import 'upload_personal_image_screen.dart';

class UserRoleSelectionPage extends StatefulWidget {
  const UserRoleSelectionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserRoleSelectionPageState createState() => _UserRoleSelectionPageState();
}

class _UserRoleSelectionPageState extends State<UserRoleSelectionPage> {
  bool btnIsLoading = false;
  String _userRole = 'Author';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _saveUserRole() async {
    setState(() {
      btnIsLoading = true;
    });
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'userType': _userRole});

        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const UploadPersonalImageScreen(),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No user logged in',
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
    } catch (e) {
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
      setState(() {
        btnIsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AbsorbPointer(
        absorbing: btnIsLoading,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: cGreen,
            title: Text(
              'Select Account Type',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold, fontSize: 16.sp, color: cWhite),
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "  You are..",
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp),
                ),
                SizedBox(height: 10.h),
                RadioListTile<String>(
                  activeColor: cGreen3,
                  title: Text(
                    'Author',
                    style: GoogleFonts.inter(
                        fontSize: 15.sp, fontWeight: FontWeight.w500),
                  ),
                  value: 'Author',
                  groupValue: _userRole,
                  onChanged: (value) {
                    setState(() {
                      _userRole = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  activeColor: cGreen3,
                  title: Text(
                    'Reader',
                    style: GoogleFonts.inter(
                        fontSize: 15.sp, fontWeight: FontWeight.w500),
                  ),
                  value: 'Reader',
                  groupValue: _userRole,
                  onChanged: (value) {
                    setState(() {
                      _userRole = value!;
                    });
                  },
                ),
                SizedBox(height: 20.h),
                Center(
                    child: Container(
                  height: 40.h,
                  width: 235.w,
                  decoration: BoxDecoration(
                    color: cGreen,
                    borderRadius: BorderRadius.circular(36.0),
                  ),
                  child: TextButton(
                    onPressed: _saveUserRole,
                    child: btnIsLoading
                        ? ImageAsset(
                            imagePath: "assets/images/loading.gif",
                            height: 50.h,
                            width: 50.w,
                          )
                        : Text(
                            "Next",
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
