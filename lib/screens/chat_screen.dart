import 'package:anees/screens/widgets/txtformfield.dart';
import 'package:anees/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              SvgPicture.asset(
                'assets/images/Ellipse-chat.svg',
                fit: BoxFit.fill,
              ),
              Positioned(
                  left: 132.w,
                  right: 40.w,
                  top: 40.h,
                  child: SafeArea(
                      child: Text(
                    "Messages",
                    style: GoogleFonts.aclonica(
                        fontWeight: FontWeight.bold,
                        color: cGreen,
                        fontSize: 18.sp),
                  ))),
              Positioned(
                  left: 0.w,
                  top: 60.h,
                  child: SvgPicture.asset(
                    "assets/images/Ellipse-001.svg",
                    fit: BoxFit.fill,
                  )),
              Positioned(
                  left: 50.w,
                  top: 95.h,
                  child: SvgPicture.asset(
                    "assets/images/Ellipse-002.svg",
                    fit: BoxFit.fill,
                  )),
              Positioned(
                  left: 120.w,
                  top: 0.h,
                  child: SafeArea(
                    child: SvgPicture.asset(
                      "assets/images/Ellipse-003.svg",
                      fit: BoxFit.fill,
                    ),
                  )),
              Positioned(
                  right: 80.w,
                  top: 0.h,
                  child: SafeArea(
                    child: SvgPicture.asset(
                      "assets/images/Ellipse-004.svg",
                      fit: BoxFit.fill,
                    ),
                  )),
              Positioned(
                  right: 0.w,
                  top: 0.h,
                  child: SafeArea(
                    child: SvgPicture.asset(
                      "assets/images/Ellipse-005.svg",
                      fit: BoxFit.fill,
                    ),
                  ))
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Txtformfield(
              text: "Search for chat...",
              suffixIcon: Icons.search_rounded,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40.h,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Container(
                        height: 40.h,
                        width: 90.w,
                        decoration: index == 0
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF77B0AA),
                                    Color(0xFF003C43)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              )
                            : BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.shade500,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                              child: Text(
                            "All",
                            style: GoogleFonts.poly(
                              color: index == 0 ? cWhite : Colors.grey.shade500,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                          )),
                        ),
                      ),
                  separatorBuilder: (context, index) => SizedBox(
                        width: 10.w,
                      ),
                  itemCount: 5),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.separated(
                  itemBuilder: (context, index) => Container(
                        // height: 80.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22.r,
                                    backgroundImage: const AssetImage(
                                      "assets/images/person.png",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Sultan Almousa",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(".1h",
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.sp,
                                                )),
                                          ],
                                        ),
                                        Text(
                                          "What book are readind?",
                                          style: GoogleFonts.inter(
                                              fontSize: 13.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 5.h,
                      ),
                  itemCount: 2),
            ),
          )
        ],
      ),
    );
  }
}
