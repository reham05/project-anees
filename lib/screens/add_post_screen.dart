// ignore_for_file: prefer_const_constructors, unused_import, unnecessary_null_comparison, non_constant_identifier_names

import 'dart:developer';
import 'dart:io';

import 'package:anees/utils/colors.dart';

import 'package:anees/utils/image_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController description = TextEditingController();
  bool btnIsLoading = false;
  File? pickedImage;
  void selectimage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var selectedImage = File(image!.path);
    if (image != null) {
      setState(() {
        pickedImage = selectedImage;
      });
    }
  }

  void upload_post() async {
    setState(() {
      btnIsLoading = true;
    });
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      final userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      String formattedDate = DateFormat('MMM d, yyyy').format(DateTime.now());

      final uuid = Uuid().v4();
      String? imageUrl = '';
      if (pickedImage != null) {
        final rref = FirebaseStorage.instance
            .ref()
            .child('postsImage')
            .child('${uuid}jpg');
        await rref.putFile(pickedImage!);
        imageUrl = await rref.getDownloadURL();
      }
      FirebaseFirestore.instance.collection("posts").doc(uuid).set({
        'fullName': userData['fullName'],
        'uid': uid,
        'userImage': userData['profile_picture_url'],
        'imagepost': imageUrl.isNotEmpty ? imageUrl : '',
        'postid': uuid,
        'des': description.text,
        'createdAt': formattedDate,
        'likes': [],
        'share_count':0
      });
      setState(() {
        pickedImage = null;
        description.text = "";
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Done',
            style: GoogleFonts.inter(
              color: cWhite,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: cGreen,
        ),
      );
      setState(() {
        btnIsLoading = false;
      });
    } on FirebaseException catch (e) {
      log(e.toString());
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred, please try again',
            style: GoogleFonts.inter(
              color: cWhite,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        btnIsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;
    return AbsorbPointer(
      absorbing: btnIsLoading,
      child: Scaffold(
        backgroundColor: cGreen2,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.cancel,
                            color: cGreen,
                            size: 26.sp,
                          )),
                      Text(
                        "New Post",
                        style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            color: cGreen,
                            fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: upload_post,
                          child: btnIsLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    color: cWhite,
                                  ))
                              : Text(
                                  "Next",
                                  style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      color: cGreen,
                                      fontWeight: FontWeight.bold),
                                ))
                    ],
                  ),
                  pickedImage != null
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: height * 0.3,
                            width: double.infinity,
                            child: Image.file(
                              pickedImage!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                        controller: description,
                        maxLines: 10,
                        cursorColor: cGreen,
                        style: GoogleFonts.rubik(color: cWhite),
                        decoration: InputDecoration(
                          hintText: "Typing Post...",
                          hintStyle:
                              GoogleFonts.inter(fontStyle: FontStyle.italic),
                          border: InputBorder.none,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            selectimage();
          },
          backgroundColor: cGreen,
          elevation: 3.0,
          child: const Icon(
            Icons.image,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
