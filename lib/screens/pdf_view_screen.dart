import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  // ignore: use_key_in_widget_constructors
  const PDFViewerScreen(this.pdfUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View PDF")),
      body: PDFView(
        filePath: pdfUrl,
      ),
    );
  }
}
