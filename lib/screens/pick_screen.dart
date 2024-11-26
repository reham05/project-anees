import 'package:anees/screens/home.dart';
import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/image_util.dart';
import 'widgets/interests_widget.dart';

class PickScreen extends StatefulWidget {
  const PickScreen({super.key});

  @override
  State<PickScreen> createState() => _PickScreenState();
}

class _PickScreenState extends State<PickScreen> {
  bool btnIsLoading = false;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  List<String> selectedInterests = [];

  void saveInterests() async {
    if (selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You must select at least one",
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
      return;
    }
    setState(() {
      btnIsLoading = true;
    });
    String? uid = FirebaseAuth.instance.currentUser!.uid;
    _databaseReference.child('users_interests').child(uid).set({
      'interests': selectedInterests,
    }).then((_) async {
      // ignore: use_build_context_synchronously
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({"completedPickInterest": true});
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ));
    }).catchError((error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save interests',
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
    });
  }

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AbsorbPointer(
        absorbing: btnIsLoading,
        child: Scaffold(
          backgroundColor: cWhite,
          body: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: SvgPicture.asset(
                      'assets/images/Ellipse-pick.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    bottom: 25.h,
                    left: 40.w,
                    child: SvgPicture.asset(
                      'assets/images/Ellipse-04.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 0.h,
                    left: 70.w,
                    child: SafeArea(
                      child: SvgPicture.asset(
                        'assets/images/Ellipse-06.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.h,
                    left: 150.w,
                    child: SafeArea(
                      child: SvgPicture.asset(
                        'assets/images/Ellipse-07.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 55.h,
                    right: 25.w,
                    child: SvgPicture.asset(
                      'assets/images/Ellipse-05.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 0.h,
                    right: -5.w,
                    child: SafeArea(
                      child: SvgPicture.asset(
                        'assets/images/Ellipse-08.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 31.h,
                    bottom: 28.h,
                    left: 65.w,
                    right: 45.w,
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Pick your interests",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Center(
                            child: Text(
                              "We’ll use this info to personalize your",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "feed to recommend things you’ll like.",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        Expanded(
                          child: InterestsWidget(
                            text: "Fiction",
                            image: "assets/images/fiction.png",
                            isSelected: selectedInterests.contains("Fiction"),
                            onChanged: () => toggleInterest("Fiction"),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: InterestsWidget(
                            text: "Business",
                            image: "assets/images/business.png",
                            isSelected: selectedInterests.contains("Business"),
                            onChanged: () => toggleInterest("Business"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Expanded(
                          child: InterestsWidget(
                            text: "Biography",
                            image: "assets/images/biography.png",
                            isSelected: selectedInterests.contains("Biography"),
                            onChanged: () => toggleInterest("Biography"),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: InterestsWidget(
                            text: "Health",
                            image: "assets/images/health.png",
                            isSelected: selectedInterests.contains("Health"),
                            onChanged: () => toggleInterest("Health"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Expanded(
                          child: InterestsWidget(
                            text: "Literary Criticism",
                            image: "assets/images/literay-criticism.png",
                            isSelected: selectedInterests
                                .contains("Literary Criticism"),
                            onChanged: () =>
                                toggleInterest("Literary Criticism"),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: InterestsWidget(
                            text: "Social Science",
                            image: "assets/images/english.png",
                            isSelected:
                                selectedInterests.contains("Social Science"),
                            onChanged: () => toggleInterest("Social Science"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Expanded(
                          child: InterestsWidget(
                            text: "History",
                            image: "assets/images/history.png",
                            isSelected: selectedInterests.contains("History"),
                            onChanged: () => toggleInterest("History"),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: InterestsWidget(
                            text: "Science",
                            image: "assets/images/Science.png",
                            isSelected: selectedInterests.contains("Science"),
                            onChanged: () => toggleInterest("Science"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.h),
                    Center(
                      child: Container(
                        height: 40.h,
                        width: 235.w,
                        decoration: BoxDecoration(
                          color: cGreen,
                          borderRadius: BorderRadius.circular(36.0),
                        ),
                        child: TextButton(
                          onPressed: saveInterests,
                          child: btnIsLoading
                              ? ImageAsset(
                                  imagePath: "assets/images/loading.gif",
                                  height: 50.h,
                                  width: 50.w,
                                )
                              : Text(
                                  "Save",
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: cWhite,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
