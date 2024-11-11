import 'package:anees/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookViewerScreen extends StatelessWidget {
  // final String pdfUrl;

  const BookViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: cGreen,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: cGreen,
          titleTextStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: cWhite,
            fontSize: 20.sp,
          ),
          iconTheme: const IconThemeData(color: cWhite),
        ),
      ),
      home: Scaffold(
        backgroundColor: cWhite,
        appBar: AppBar(
          backgroundColor: cGreen,
          title: Text(
            "Book Viewer",
            style: GoogleFonts.aclonica(
                fontWeight: FontWeight.bold, color: cWhite, fontSize: 20.sp),
          ),
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_ios,
                color: cWhite,
              )),
        ),
        body: SfPdfViewer.network(
            pageSpacing: 5,
            currentSearchTextHighlightColor: cGreen,
            // pageLayoutMode: PdfPageLayoutMode.single,
            "https://firebasestorage.googleapis.com/v0/b/anees-a8319.appspot.com/o/pdfs%2FNoor-Book.com%20%20%D8%A7%D9%84%D9%81%D9%8A%D8%B2%D9%8A%D8%A7%D8%A1%2030%203%20.pdf?alt=media&token=3973d096-f17c-4af0-bec9-981306cbc482"),
      ),
    );
  }
}
