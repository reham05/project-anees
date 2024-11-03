import 'dart:developer';
import 'dart:io';

import 'package:anees/screens/pdf_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class PDFListScreen extends StatelessWidget {

Future<void> uploadPDF() async {
  // Pick a PDF file
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    // Access the local file path
    final filePath = result.files.single.path;

    if (filePath != null) {
      // Create a File instance
      File file = File(filePath);

      // Upload the file to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('pdfs/${result.files.single.name}');
      await ref.putFile(file);

      // Get the file URL
      final url = await ref.getDownloadURL();

      // Save the file link to Firestore
      await FirebaseFirestore.instance.collection('pdfs').add({
        'name': result.files.single.name,
        'url': url,
      });
    } else {
      print("File path is null.");
    }
  } else {
    print("No file selected.");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Files"),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: () async {
              await uploadPDF();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('pdfs').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final pdfs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: pdfs.length,
            itemBuilder: (context, index) {
              final pdf = pdfs[index];
              return ListTile(
                title: Text(pdf['name']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerScreen(pdf['url']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
