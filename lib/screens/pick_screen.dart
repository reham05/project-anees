import 'package:anees/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/interests_widget.dart';

class PickScreen extends StatefulWidget {
  const PickScreen({super.key});

  @override
  State<PickScreen> createState() => _PickScreenState();
}

class _PickScreenState extends State<PickScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: Column(
        children: [
          Stack(
            children: [
              SvgPicture.asset(
                'assets/images/Ellipse-pick.svg',
                fit: BoxFit.fill,
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
                right: 40.w,
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
                top: 10.h,
                bottom: 30.h,
                left: 50.w,
                right: 50.w,
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
                          fontSize: 20.sp),
                    )),
                    SizedBox(
                      height: 5.h,
                    ),
                    Center(
                        child: Text(
                      "We’ll use this info to personalize your",
                      style: GoogleFonts.inter(
                          color: Colors.black, fontSize: 13.sp),
                    )),
                    Center(
                        child: Text(
                      "feed to recommend things you’ll like.",
                      style: GoogleFonts.inter(
                          color: Colors.black, fontSize: 13.sp),
                    )),
                  ],
                )),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: InterestsWidget(
                        text: "Poetry",
                        image: "assets/images/poetry.png",
                      ),
                    ),
                    SizedBox(width: 5.w),
                    const Expanded(
                      child: InterestsWidget(
                        text: "Business",
                        image: "assets/images/poetry.png",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: InterestsWidget(
                        text: "Fantacy",
                        image: "assets/images/poetry.png",
                      ),
                    ),
                    SizedBox(width: 5.w),
                    const Expanded(
                      child: InterestsWidget(
                        text: "Detective",
                        image: "assets/images/poetry.png",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: InterestsWidget(
                        text: "English",
                        image: "assets/images/poetry.png",
                      ),
                    ),
                    SizedBox(width: 5.w),
                    const Expanded(
                      child: InterestsWidget(
                        text: "Arabic",
                        image: "assets/images/poetry.png",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: InterestsWidget(
                        text: "History",
                        image: "assets/images/poetry.png",
                      ),
                    ),
                    SizedBox(width: 5.w),
                    const Expanded(
                      child: InterestsWidget(
                        text: "Technology",
                        image: "assets/images/poetry.png",
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
                    onPressed: () {
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>HomeScreen() ,))
                    },
                    child: Text(
                      "Save",
                      style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: cWhite),
                    ),
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
