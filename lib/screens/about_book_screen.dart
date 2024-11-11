import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class AboutBookScreen extends StatefulWidget {
  const AboutBookScreen({super.key});

  @override
  State<AboutBookScreen> createState() => _AboutBookScreenState();
}

class _AboutBookScreenState extends State<AboutBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cGreen4,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      backgroundColor: cWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: cGreen4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                          height: 200.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      "assets/images/Frame-50.png")))),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    TextButton(
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(cGreen),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Read the Book",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500, color: cWhite),
                        ))
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 20.h,
            width: double.infinity,
            color: cWhite,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: cGreen,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description:",
                        style: GoogleFonts.inter(
                            color: cWhite,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "A late work by the Egyptian Nobel literature laureate, Morning and  Evening Talk is an epic tale of Egyptian life over five generations. Set  in Cairo, it traces the fortunes of three families from the arrival of  Napoleon at the end of the eighteenth century to the 1980s, using short  character sketches arranged in alphabetical order. This highly  experimental device produces a kind of biographical dictionary, whose  individual entries come together to paint a vivid portrait of life in  Cairo from a range of different perspectives",
                        style: GoogleFonts.inter(
                            color: cWhite,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w200),
                      ),
                      const Divider(
                        color: cWhite,
                      ),
                      Row(
                        children: [
                          Text(
                            "Page: ",
                            style: GoogleFonts.inter(
                                color: cWhite,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "204 pages",
                            style: GoogleFonts.inter(
                                color: cWhite,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                      const Divider(
                        color: cWhite,
                      ),
                      Row(
                        children: [
                          Text(
                            "Written: ",
                            style: GoogleFonts.inter(
                                color: cWhite,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "1987 (Eng. 2007)",
                            style: GoogleFonts.inter(
                                color: cWhite,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
