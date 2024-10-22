import 'package:anees/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class AuthorProfileScreen extends StatefulWidget {
  const AuthorProfileScreen({super.key});

  @override
  State<AuthorProfileScreen> createState() => _AuthorProfileScreenState();
}

class _AuthorProfileScreenState extends State<AuthorProfileScreen> {
  int? index = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: cWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SvgPicture.asset(
                'assets/images/Ellipse-author-profile.svg',
                fit: BoxFit.fill,
              ),
              Container(
                color: cGreen4,
                height: 30.h,
                width: double.infinity,
              ),

              // Positioned(
              //     child: SafeArea(
              //   child: IconButton(
              //       onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
              // )),
              Positioned(
                left: 50.w,
                right: 50.w,
                top: 20.h,
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        width: 120.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cGreen,
                            width: 5.0,
                          ),
                          // image: DecorationImage(
                          //     image: const AssetImage("assets/images/person.png"),
                          //     fit: BoxFit.fill,
                          //     scale: 3),
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: 57.r,
                            backgroundImage:
                                const AssetImage("assets/images/person.png"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Osamah Almuslim",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: SizedBox(
              width: width / 1.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "26",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, fontSize: 14.sp),
                      ),
                      Text(
                        "Book",
                        style: GoogleFonts.poly(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade500,
                            fontSize: 14.sp),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "10k",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, fontSize: 14.sp),
                      ),
                      Text(
                        "Followers",
                        style: GoogleFonts.poly(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade500,
                            fontSize: 14.sp),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "2",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, fontSize: 14.sp),
                      ),
                      Text(
                        "Posts",
                        style: GoogleFonts.poly(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade500,
                            fontSize: 14.sp),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
                width: width / 1.4,
                child: const Divider(
                  thickness: 2,
                )),
          ),
          SizedBox(
            height: 5.h,
          ),
          Center(
            child: SizedBox(
              width: width / 1.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Text(
                      "Author’s Books",
                      style: GoogleFonts.inter(
                          fontWeight:
                              index == 0 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13.sp),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Text(
                      "Posts",
                      style: GoogleFonts.inter(
                          fontWeight:
                              index == 1 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13.sp),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          index == 0
              ? Expanded(
                  child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: cGreen4,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Container(
                              height: 150.h,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/demobook.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Center(
                              child: Expanded(
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  'Arabistan orchards-1',
                                  style: GoogleFonts.inter(
                                      color: cGreen,
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ))
              : Expanded(
                  child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  child: ListView.separated(
                      itemBuilder: (context, index) => Container(
                            // height: 150.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: cGreen4,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text("Sultan Almousa",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.inter(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Text("Jan 1, 2024",
                                                style: GoogleFonts.inter(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.rtl,
                                          "هدية بسيطة لكم أتمنى تعجبكم، وهي عبارة عن قصة تاريخية قصيرة كتبتها هذه الأيام بعنوان كبيرة الورد."),
                                      index == 0
                                          ? SizedBox.shrink()
                                          : SizedBox(
                                              height: 5.h,
                                            ),
                                      index == 0
                                          ? SizedBox.shrink()
                                          : Container(
                                              height: 150.h,
                                              // width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: cGreen,
                                                  image: const DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/demoimage.png"),
                                                      fit: BoxFit.fill),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                      index == 0
                                          ? SizedBox.shrink()
                                          : SizedBox(
                                              height: 5.h,
                                            ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Transform(
                                              alignment: Alignment.center,
                                              transform:
                                                  Matrix4.rotationY(3.14),
                                              child: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.reply,
                                                    size: 23.sp,
                                                  ))),
                                          Text("10"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.comment_rounded,
                                                size: 23.sp,
                                              )),
                                          Text("10"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.favorite_border,
                                                size: 23.sp,
                                              )),
                                          Text("1k"),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10.h,
                          ),
                      itemCount: 3),
                )),
        ],
      ),
    );
  }
}
