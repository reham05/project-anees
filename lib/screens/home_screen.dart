import 'package:anees/screens/authors_screen.dart';
import 'package:anees/screens/chatbot_screen.dart';
import 'package:anees/screens/settings_screen.dart';
import 'package:anees/screens/widgets/txtformfield.dart';
import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'profile_screen.dart';

const filters = [
  {'image': "assets/images/novels.png", 'text': "Novels"},
  {'image': "assets/images/poetry.png", 'text': "Poerty"},
  {'image': "assets/images/stories.png", 'text': "Stories"},
  {'image': "assets/images/arabic.png", 'text': "Arabic"},
];
const mostSearch = [
  "Popular",
  "Best seller",
  "New Releases",
  "Romantic",
  "Technology",
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 1;
  var uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned(
                  top: 0.h,
                  left: 0.w,
                  child: SvgPicture.asset(
                    'assets/images/Ellipse-01.svg',
                  ),
                ),
                Positioned(
                  top: 146.h,
                  left: 10.w,
                  child: SvgPicture.asset(
                    'assets/images/Ellipse-02.svg',
                  ),
                ),
                Positioned(
                  top: 0.h,
                  left: 170.w,
                  child: SvgPicture.asset(
                    'assets/images/Ellipse-03.svg',
                  ),
                ),
                Positioned(
                  top: 50.h,
                  left: 30.w,
                  child: Column(
                    children: [
                      Text(
                        "Welcome to",
                        style: GoogleFonts.dancingScript(
                            color: cGreen,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Anees",
                        style: GoogleFonts.dancingScript(
                            color: cGreen,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 40),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsScreen(),
                                    ));
                              },
                              child: SvgPicture.asset(
                                'assets/images/setting.svg',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 10, bottom: 60),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ChatBotScreen(),
                                    ));
                              },
                              child: CircleAvatar(
                                radius: 19.r,
                                backgroundImage: const AssetImage(
                                  'assets/images/chatbot.png',
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Txtformfield(
                    text: "Search for books, Author, Reader..",
                    suffixIcon: Icons.search_rounded,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 60.h,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                                height: 70.h,
                                width: 85.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          filters[index]['image'].toString()),
                                      fit: BoxFit.cover,
                                    )),
                                child: Center(
                                    child: Expanded(
                                  child: Text(
                                    filters[index]['text'].toString(),
                                    style: GoogleFonts.poppins(
                                        color: cWhite,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                              ),
                          separatorBuilder: (context, index) => SizedBox(
                                width: 15.w,
                              ),
                          itemCount: filters.length),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Most Searched",
                          style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: cGreen),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40.h,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                                height: 40.h,
                                // width: 120.w,
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
                                    mostSearch[index],
                                    style: GoogleFonts.poly(
                                      color: index == 0
                                          ? cWhite
                                          : Colors.grey.shade500,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                    ),
                                  )),
                                ),
                              ),
                          separatorBuilder: (context, index) => SizedBox(
                                width: 15.w,
                              ),
                          itemCount: mostSearch.length),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Books",
                          style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: cGreen),
                        ),
                        Row(
                          children: [
                            Text("More",
                                style: GoogleFonts.inter(
                                    color: Colors.grey.shade700,
                                    fontSize: 11.sp)),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12.sp,
                              color: Colors.grey.shade700,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 165.h,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                                // height: 100.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                    color: cGreen4,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 120.h,
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/Frame-50.png"),
                                              fit: BoxFit.fill,
                                            )),
                                      ),
                                    ),
                                    Text(
                                      "Morning and Evening Talk",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 8.sp),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      " Naguib Mahfouz",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade500,
                                          fontSize: 8.sp),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                          separatorBuilder: (context, index) => SizedBox(
                                width: 15.w,
                              ),
                          itemCount: 5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Authors",
                          style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: cGreen),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AuthorsScreen()));
                              },
                              child: Text("More",
                                  style: GoogleFonts.inter(
                                      color: Colors.grey.shade700,
                                      fontSize: 11.sp)),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12.sp,
                              color: Colors.grey.shade700,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 130.h,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('userType', isEqualTo: 'Author')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: cGreen,
                            ));
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          final authors = snapshot.data!.docs
                              .map((doc) => doc.data() as Map<String, dynamic>)
                              .toList();

                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final author = authors[index];
                              if (author['uid'] == uid) {
                                return const SizedBox.shrink();
                              }
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                          userId: author['uid'],
                                          fromHome: false,
                                        ),
                                      ));
                                },
                                child: Container(
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    color: cGreen4,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5.h),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          height: 90.h,
                                          width: 70.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            image: DecorationImage(
                                              image: NetworkImage(author[
                                                  'profile_picture_url']),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        author['fullName'],
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          color: cGreen,
                                          fontSize: 8.sp,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              final author = authors[index];
                              if (author['uid'] ==
                                  FirebaseAuth.instance.currentUser!.uid) {
                                return const SizedBox.shrink();
                              }

                              return SizedBox(width: 15.w);
                            },
                            itemCount: authors.length,
                          );
                        },
                      ),
                    ),
                  )
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         "Posts",
                  //         style: GoogleFonts.roboto(
                  //             fontSize: 13.sp,
                  //             fontWeight: FontWeight.w700,
                  //             color: cGreen),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: SizedBox(
                  //     height: 150.h,
                  //     child: ListView.separated(
                  //         scrollDirection: Axis.horizontal,
                  //         itemBuilder: (context, index) => Container(
                  //               // height: 100.h,
                  //               width: 320.w,
                  //               decoration: BoxDecoration(
                  //                   color: cGreen4,
                  //                   borderRadius: BorderRadius.circular(20)),
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   children: [
                  //                     Row(
                  //                       children: [
                  //                         CircleAvatar(
                  //                           radius: 22.r,
                  //                           backgroundImage: const AssetImage(
                  //                             "assets/images/person.png",
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           width: 5.w,
                  //                         ),
                  //                         Expanded(
                  //                           child: Row(
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment
                  //                                     .spaceBetween,
                  //                             children: [
                  //                               Expanded(
                  //                                 child: Text("Sultan Almousa",
                  //                                     maxLines: 2,
                  //                                     overflow:
                  //                                         TextOverflow.ellipsis,
                  //                                     style: GoogleFonts.inter(
                  //                                         fontSize: 14.sp,
                  //                                         fontWeight:
                  //                                             FontWeight.bold)),
                  //                               ),
                  //                               Text("Jan 1, 2024",
                  //                                   style: GoogleFonts.inter(
                  //                                       fontSize: 12.sp,
                  //                                       fontWeight:
                  //                                           FontWeight.bold)),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     const Text(
                  //                         maxLines: 2,
                  //                         overflow: TextOverflow.ellipsis,
                  //                         textDirection: TextDirection.rtl,
                  //                         "هدية بسيطة لكم أتمنى تعجبكم، وهي عبارة عن قصة تاريخية قصيرة كتبتها هذه الأيام بعنوان كبيرة الورد."),
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Row(
                  //                           children: [
                  //                             Transform(
                  //                                 alignment: Alignment.center,
                  //                                 transform:
                  //                                     Matrix4.rotationY(3.14),
                  //                                 child: IconButton(
                  //                                     onPressed: () {},
                  //                                     icon: Icon(
                  //                                       Icons.reply,
                  //                                       size: 23.sp,
                  //                                     ))),
                  //                             const Text("10"),
                  //                           ],
                  //                         ),
                  //                         Row(
                  //                           children: [
                  //                             IconButton(
                  //                                 onPressed: () {},
                  //                                 icon: Icon(
                  //                                   Icons.comment_rounded,
                  //                                   size: 23.sp,
                  //                                 )),
                  //                             const Text("10"),
                  //                           ],
                  //                         ),
                  //                         Row(
                  //                           children: [
                  //                             IconButton(
                  //                                 onPressed: () {},
                  //                                 icon: Icon(
                  //                                   Icons.favorite_border,
                  //                                   size: 23.sp,
                  //                                 )),
                  //                             const Text("1k"),
                  //                           ],
                  //                         )
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //         separatorBuilder: (context, index) => SizedBox(
                  //               width: 10.w,
                  //             ),
                  //         itemCount: 5),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
