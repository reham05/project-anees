import 'package:anees/screens/add_feedback_screen.dart';
import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key, this.book});
  final Map<String, dynamic>? book;
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
                            image: DecorationImage(
                              image: NetworkImage(widget.book!['urlBookCover']),
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
                    widget.book!['title'],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    widget.book!['authorName'],
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500),
                  ),
                ),
                SizedBox(
                  height: 35.h,
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
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddFeedbackScreen(
                                    bookUserid: widget.book!['authorid'],
                                    bookid: widget.book!['bookid'],
                                    book: widget.book,
                                  ),
                                ));
                          },
                          icon: const Icon(
                            Icons.add_comment,
                            color: cGreen,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('books')
                        .doc(widget.book!['bookid'])
                        .collection('feedbacks')
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No Feedbacks yet"));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> feedbackData =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: cGreen2,
                              backgroundImage:
                                  NetworkImage(feedbackData['userImage'] ?? ''),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(feedbackData['fullName']),
                                Text(
                                  DateFormat.MMMEd()
                                      .format(feedbackData['date'].toDate()),
                                  style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            subtitle: Text(feedbackData['feedback']),
                          );
                        },
                      );
                    },
                  ),
                ),
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
