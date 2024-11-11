import 'package:anees/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/Ellipse-book.svg',
            fit: BoxFit.fill,
            // height: 300.h,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: cGreen,
                          )),
                      IconButton(
                        onPressed: () {},
                        icon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedBook01,
                          color: cGreen,
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: cGreen, borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 120.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/Frame-50.png"),
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Center(
                  child: Text(
                    "Morning and evening talk",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Naguib Mahfouz",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500),
                  ),
                ),
                SizedBox(
                  height: 60.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const NewWidget(
                      text: "Fiction",
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    const NewWidget(
                      text: "Classics",
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    const NewWidget(
                      text: "Novel",
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const NewWidget(
                      text: "English",
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    const NewWidget(
                      text: "Arabic",
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Feedbacks",
                        style: GoogleFonts.inter(
                            color: cGreen, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_comment,
                            color: cGreen,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: cGreen4,
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Khaled Abubakr",
                                  style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "5 Nov",
                                  style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            subtitle: Text(
                              "commentMap['comment']",
                              style: GoogleFonts.inter(fontSize: 12.sp),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: cGreen2,
                              radius: 20.r,
                              backgroundImage: const NetworkImage(""),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  final String? text;
  const NewWidget({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 90.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: cGreen4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Text(
            text!,
            style:
                GoogleFonts.inter(color: cGreen, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
