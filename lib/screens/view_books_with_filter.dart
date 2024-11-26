import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'about_book_screen.dart';

class ViewBooksWithFilter extends StatefulWidget {
  const ViewBooksWithFilter({super.key, required this.category});
  final String? category;
  @override
  State<ViewBooksWithFilter> createState() => _ViewBooksWithFilterState();
}

class _ViewBooksWithFilterState extends State<ViewBooksWithFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cWhite,
        appBar: AppBar(
          backgroundColor: cGreen,
          toolbarHeight: 70.h,
          title: Text(
            widget.category.toString(),
            style: GoogleFonts.aclonica(color: Colors.white, fontSize: 22.sp),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: cWhite,
              )),
        ),
        body: Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('books')
                .where('category', isEqualTo: widget.category)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: cGreen,
                ));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No books found"));
              }

              var books = snapshot.data!.docs;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.6,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  var book = books[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutBookScreen(
                              book: book.data() as Map<String, dynamic>,
                            ),
                          ));
                    },
                    child: Container(
                      height: 135.h,
                      decoration: BoxDecoration(
                        color: cGreen4,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 150.h,
                            decoration: BoxDecoration(
                              color: cGreen4,
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(book['urlBookCover']),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Center(
                            child: Text(
                              book['title'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                color: cGreen,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              " ${book['authorName']}",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade500,
                                  fontSize: 8.sp),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        )));
  }
}
