import 'dart:io';

import 'package:anees/screens/pick_screen.dart';
import 'package:anees/utils/colors.dart';
import 'package:anees/utils/image_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UploadPersonalImageScreen extends StatefulWidget {
  const UploadPersonalImageScreen({super.key});

  @override
  State<UploadPersonalImageScreen> createState() =>
      _UploadPersonalImageScreenState();
}

class _UploadPersonalImageScreenState extends State<UploadPersonalImageScreen> {
  final ImagePicker _picker = ImagePicker();
  bool btnIsLoading = false;
  File? _imageFile;
  String? _downloadURL;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  Future<void> _pickImageFromCamera() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    setState(() {
      btnIsLoading = true;
    });
    try {
      Reference storageRef =
          FirebaseStorage.instance.ref().child('$userId/profile_picture/me');

      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;

      _downloadURL = await snapshot.ref.getDownloadURL();

      await _saveImageUrlToFirestore(_downloadURL!);
    } catch (e) {
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

  Future<void> _saveImageUrlToFirestore(String downloadURL) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profile_picture_url': downloadURL,
    });
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const PickScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AbsorbPointer(
        absorbing: btnIsLoading,
        child: Scaffold(
          backgroundColor: cWhite,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PickScreen(),
                                  ));
                            },
                            child: Text(
                              "Skip",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.sp,
                                  color: Colors.grey.shade600),
                            ))
                      ],
                    ),
                    Text(
                      "Profile Picture",
                      style: GoogleFonts.aclonica(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: cGreen),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Text(
                        style: GoogleFonts.inter(
                            letterSpacing: 5,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            fontSize: 17.sp),
                        "Choose your profile picture.",
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 80.r,
                          // backgroundColor: Colors.grey,
                          backgroundImage: _imageFile == null
                              ? const AssetImage("assets/images/iconPerson.png")
                              : FileImage(_imageFile!),
                          backgroundColor: Colors.grey.shade300,
                        ),
                        Positioned(
                          bottom: 10.h,
                          right: 15.w,
                          child: CircleAvatar(
                            radius: 15.r,
                            backgroundColor: Colors.grey.shade300,
                            child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      if (_imageFile == null) {
                                        _showBottomSheet(context);
                                      } else {
                                        setState(() {
                                          _imageFile = null;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      _imageFile == null
                                          ? Icons.add
                                          : Icons.delete,
                                      size: 15.sp,
                                      color: _imageFile == null
                                          ? Colors.black
                                          : Colors.red,
                                    ))),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50.h,
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
                          if (_imageFile == null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PickScreen()));
                          } else {
                            _uploadImage();
                          }
                        },
                        child: btnIsLoading
                            ? ImageAsset(
                                height: 50.h,
                                width: 50.w,
                                imagePath: "assets/images/loading.gif")
                            : Text(
                                "Next",
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
        ),
      ),
    );
  }
}
