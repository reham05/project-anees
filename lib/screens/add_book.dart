// // ignore_for_file: duplicate_import, unused_import

// import 'dart:developer';
// import 'dart:io';

// import 'package:anees/screens/pdf_view_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';

// // ignore: use_key_in_widget_constructors
// class PDFListScreen extends StatelessWidget {
//   Future<void> uploadPDF() async {
//     // Pick a PDF file
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       // Access the local file path
//       final filePath = result.files.single.path;

//       if (filePath != null) {
//         // Create a File instance
//         File file = File(filePath);

//         // Upload the file to Firebase Storage
//         final ref = FirebaseStorage.instance
//             .ref()
//             .child('pdfs/${result.files.single.name}');
//         await ref.putFile(file);

//         // Get the file URL
//         final url = await ref.getDownloadURL();

//         // Save the file link to Firestore
//         await FirebaseFirestore.instance.collection('pdfs').add({
//           'name': result.files.single.name,
//           'url': url,
//         });
//       } else {
//         // ignore: avoid_print
//         print("File path is null.");
//       }
//     } else {
//       // ignore: avoid_print
//       print("No file selected.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("PDF Files"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.upload_file),
//             onPressed: () async {
//               await uploadPDF();
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('pdfs').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             // ignore: prefer_const_constructors
//             return Center(child: CircularProgressIndicator());
//           }
//           final pdfs = snapshot.data!.docs;
//           return ListView.builder(
//             itemCount: pdfs.length,
//             itemBuilder: (context, index) {
//               final pdf = pdfs[index];
//               return ListTile(
//                 title: Text(pdf['name']),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const BookViewerScreen(),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'dart:io';

import 'package:anees/screens/widgets/txtformfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../utils/colors.dart';
import '../utils/image_util.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final _formKey = GlobalKey<FormState>();
  bool isLoadingPage = true;
  String? myName;
  bool btnIsLoading = false;
  File? pickedImage;
  String? _selectedCategory;
  File? _selectedFile;

  TextEditingController bookTitle = TextEditingController();
  TextEditingController numberOfPages = TextEditingController();
  TextEditingController bookWritten = TextEditingController();
  TextEditingController description = TextEditingController();
  Future<void> fetchCurrentUser() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      myName = snapshot.data()!['fullName'];
      isLoadingPage = false;
    });
  }

  Future<void> pickPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final filePath = result.files.single.path;

      if (filePath != null) {
        setState(() {
          _selectedFile = File(filePath);
        });
      } else {
        log("File path is null.");
      }
    } else {
      log("No file selected.");
    }
  }

  Future<void> uploadPDFToFirebase({
    required String bookTitle,
    required String numberOfPages,
    required String bookDescription,
    required String written,
    required String authorName,
    required String category,
  }) async {
    if (_selectedFile != null) {
      setState(() {
        btnIsLoading = true;
      });
      try {
        final uuid = const Uuid().v4();
        String? imageUrl = '';
        if (pickedImage != null) {
          final rref = FirebaseStorage.instance
              .ref()
              .child('books/')
              .child('$uuid/${uuid}jpg');
          await rref.putFile(pickedImage!);
          imageUrl = await rref.getDownloadURL();
        }
        final ref = FirebaseStorage.instance
            .ref()
            .child('books/$uuid/${_selectedFile!.uri.pathSegments.last}');
        await ref.putFile(_selectedFile!);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('books').doc(uuid).set({
          'bookid': uuid,
          'title': bookTitle,
          'description': bookDescription,
          'numOfPages': numberOfPages,
          'written': written,
          'urlBook': url,
          'urlBookCover': imageUrl,
          'authorid': FirebaseAuth.instance.currentUser!.uid,
          'authorName': authorName,
          'category': category,
          'uploadDate': Timestamp.now(),
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: cGreen,
            content: Text(
              'The book has been added successfully',
              style: GoogleFonts.inter(
                color: cWhite,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            )));
        setState(() {
          btnIsLoading = false;
        });
      } catch (e) {
        log("Error uploading file: $e");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Something went wrong, please try again',
                style: GoogleFonts.inter(
                  color: cWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              )),
        );
        setState(() {
          btnIsLoading = false;
        });
      }
    } else {
      log("No file selected to upload.");
    }
  }

  final List<String> _bookCategories = [
    "Poetry",
    "Fantacy",
    "Business",
    "Detective",
    "English",
    "Arabic",
    "History",
    "Technology",
  ];
  void selectimage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var selectedImage = File(image!.path);
    // ignore: unnecessary_null_comparison
    if (image != null) {
      setState(() {
        pickedImage = selectedImage;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      appBar: AppBar(
        backgroundColor: cGreen,
        title: Text(
          "Add Book",
          style: GoogleFonts.aclonica(
              color: cWhite, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: cWhite,
            )),
      ),
      body: isLoadingPage
          ? const Center(
              child: CircularProgressIndicator(
                color: cGreen,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "  Book cover",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500, fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: selectimage,
                            child: Container(
                              height: 100.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: pickedImage != null
                                    ? Image.file(
                                        pickedImage!,
                                        fit: BoxFit.fill,
                                      )
                                    : Text(
                                        "select a cover",
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade500,
                                            fontSize: 12.sp),
                                      ),
                              ),
                            ),
                          ),
                          pickedImage == null
                              ? const SizedBox.shrink()
                              : TextButton(
                                  onPressed: () {
                                    setState(() {
                                      pickedImage = null;
                                    });
                                  },
                                  child: Text(
                                    "Delete",
                                    style: GoogleFonts.inter(color: Colors.red),
                                  ))
                        ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "  Book Title",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500, fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Txtformfield(
                        controller: bookTitle,
                        text: "Enter the book title",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field must not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "  Number of Pages",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500, fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Txtformfield(
                        controller: numberOfPages,
                        text: "Enter the number of pages",
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field must not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "  Book Written",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500, fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Txtformfield(
                        controller: bookWritten,
                        text: " e.g. 1987 (Eng. 2007)",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field must not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "  Category",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500, fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field must not be empty";
                          }
                          return null;
                        },
                        value: _selectedCategory,
                        hint: const Text("Select a category"),
                        dropdownColor: cWhite,
                        style: GoogleFonts.inter(
                            color: cGreen,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400),
                        items: _bookCategories.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36.0),
                            borderSide: const BorderSide(
                              color: cGrey,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36.0),
                            borderSide: const BorderSide(
                              color: cGrey,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36.0),
                            borderSide: const BorderSide(
                              color: cGreen,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "  Description",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500, fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      TextFormField(
                        controller: description,
                        maxLines: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field must not be empty";
                          }
                          return null;
                        },
                        style: GoogleFonts.inter(
                            color: cGreen,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          errorMaxLines: 999,
                          hintText: "Enter the book description...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: cGrey,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: cGrey,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: cGreen,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Colors.grey.shade200)),
                            onPressed: pickPDFFile,
                            child: const Text("Choose PDF File"),
                          ),
                          SizedBox(width: 5.w),
                          _selectedFile != null
                              ? Expanded(
                                  child: Text(
                                      "Selected File: ${_selectedFile!.uri.pathSegments.last}"),
                                )
                              : const Text("No file selected"),
                        ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Center(
                          child: Container(
                        height: 40.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cGreen,
                          borderRadius: BorderRadius.circular(36.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (pickedImage == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'You must choose a book cover',
                                          style: GoogleFonts.inter(
                                            color: cWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                          ),
                                        )));
                              } else if (_selectedFile == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'You must select the book file',
                                          style: GoogleFonts.inter(
                                            color: cWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                          ),
                                        )));
                              } else {
                                uploadPDFToFirebase(
                                    bookTitle: bookTitle.text,
                                    authorName: myName!,
                                    bookDescription: description.text,
                                    category: _selectedCategory!,
                                    numberOfPages: numberOfPages.text,
                                    written: bookWritten.text);
                              }
                            }
                          },
                          child: btnIsLoading
                              ? ImageAsset(
                                  imagePath: "assets/images/loading.gif",
                                  height: 50.h,
                                  width: 50.w,
                                )
                              : Text(
                                  "Add Book",
                                  style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: cWhite),
                                ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
