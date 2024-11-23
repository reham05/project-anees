import 'package:anees/screens/about_book_screen.dart';
import 'package:anees/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewAllRecomandationBoosk extends StatefulWidget {
  const ViewAllRecomandationBoosk({super.key, this.booksData});
  final Future<List<Map<String, dynamic>>>? booksData;

  @override
  State<ViewAllRecomandationBoosk> createState() =>
      _ViewAllRecomandationBooskState();
}

class _ViewAllRecomandationBooskState extends State<ViewAllRecomandationBoosk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      appBar: AppBar(
        backgroundColor: cGreen,
        title: Text(
          "Recommended Books",
          style: GoogleFonts.aclonica(color: Colors.white, fontSize: 18.sp),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: cWhite,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: widget.booksData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No books available"));
            }

           
            final booksList = snapshot.data!;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.6,
              ),
              itemCount: booksList.length,
              itemBuilder: (context, index) {
                var book = booksList[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutBookScreen(
                          book: book,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cGreen4,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 130.h,
                          decoration: BoxDecoration(
                            color: cGreen4,
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(book['urlBookCover']),
                              fit: BoxFit.cover,
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
      ),
    );
  }
}
