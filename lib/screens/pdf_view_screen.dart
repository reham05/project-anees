import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  PDFViewerScreen(this.pdfUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View PDF")),
      body: PDFView(
        filePath: pdfUrl,
      ),
    );
  }
}
