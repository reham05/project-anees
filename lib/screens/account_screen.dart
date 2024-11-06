import 'dart:io';

import 'package:anees/screens/widgets/txtformfield.dart';
import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/image_util.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _downloadURL;
  bool loadingPage = true;
  bool btnIsLoading = false;
  bool btnUploadImageLoading = false;
  String msg = '';
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String? _userType;
  String? _userImage;

  Future<void> _getCurrentUserData() async {
    try {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      var snapShot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      var userData = snapShot.data();
      setState(() {
        _fullName.text = userData!['fullName'];
        _email.text = userData['email'];
        _userType = userData['userType'];
        _userImage = userData['profile_picture_url'];
        msg = "successful";
        loadingPage = false;
      });
    } on Exception catch (_) {
      setState(() {
        msg = "Error";
        loadingPage = false;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio:
            const CropAspectRatio(ratioX: 1, ratioY: 1), // Customize as needed

        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedImage != null) {
        setState(() {
          _imageFile = File(croppedImage.path);
        });
      }
      _uploadImage();
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(
            ratioX: 1, ratioY: 1), // Aspect ratio 1:1; customize as needed
        // Change to .circle if you want a circular crop
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: cGreen,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedImage != null) {
        setState(() {
          _imageFile = File(croppedImage.path);
        });
      }
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    setState(() {
      btnUploadImageLoading = true;
    });
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child(
          '${FirebaseAuth.instance.currentUser!.uid}/profile_picture/me');

      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;

      _downloadURL = await snapshot.ref.getDownloadURL();

      await _saveImageUrlToFirestore(_downloadURL!);
      setState(() {
        btnUploadImageLoading = false;
        _userImage = _downloadURL;
      });
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
        btnUploadImageLoading = false;
      });
    }
  }

  Future<void> _saveImageUrlToFirestore(String downloadURL) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'profile_picture_url': downloadURL,
    });
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

  Future<void> _updateUserData(
      {required String fullName, required userType}) async {
    setState(() {
      btnIsLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'fullName': fullName,
        'userType': userType,
      });
      setState(() {
        _fullName.text = fullName;
        _userType = userType;
        btnIsLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'The data has been modified successfully',
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
    } on Exception catch (_) {
      setState(() {
        btnIsLoading = false;
      });
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
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: btnIsLoading ? btnIsLoading : btnUploadImageLoading,
      child: Scaffold(
        backgroundColor: cWhite,
        appBar: AppBar(
          backgroundColor: cWhite,
          title: Text(
            "My Account",
            style: GoogleFonts.aclonica(fontSize: 18.sp, color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: loadingPage
            ? const Center(
                child: CircularProgressIndicator(
                  color: cGreen,
                ),
              )
            : msg == "Error"
                ? Center(
                    child: Text(
                      "Error",
                      style: GoogleFonts.inter(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Center(
                                  child: CircleAvatar(
                                radius: 60.r,
                                backgroundColor: cGreen4,
                                backgroundImage: _userImage == 'not-image'
                                    ? const AssetImage(
                                        "assets/images/iconPerson.png")
                                    : NetworkImage(_userImage!),
                              )),
                              // Camera icon overlay
                              Positioned(
                                  bottom: 5,
                                  right: 128.w,
                                  child: CircleAvatar(
                                    radius: 15.r,
                                    backgroundColor: Colors.grey[300],
                                    child: IconButton(
                                        onPressed: () {
                                          _showBottomSheet(context);
                                        },
                                        icon: btnUploadImageLoading
                                            ? SizedBox(
                                                height: 12.h,
                                                width: 12.w,
                                                child:
                                                    const CircularProgressIndicator(
                                                  color: Colors.black,
                                                ),
                                              )
                                            : Icon(
                                                Icons.camera_alt,
                                                color: Colors.black,
                                                size: 15.sp,
                                              )),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "  You are..",
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              activeColor: cGreen3,
                                              value: 'Author',
                                              groupValue: _userType,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _userType = value;
                                                });
                                              },
                                            ),
                                            Text(
                                              'Author',
                                              style: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              value: 'Reader',
                                              activeColor: cGreen3,
                                              groupValue: _userType,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _userType = value;
                                                });
                                              },
                                            ),
                                            Text(
                                              'Reader',
                                              style: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    "  Name",
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Txtformfield(
                                    controller: _fullName,
                                    text: "Enter your full name",
                                    prefixIcon: Icons.person,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your full name';
                                      }

                                      if (RegExp(r'\d').hasMatch(value)) {
                                        return 'Full name must not contain numbers';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    "  Email",
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Txtformfield(
                                    controller: _email,
                                    readOnly: true,
                                    text: "Email address",
                                    prefixIcon: Icons.email,
                                    suffixIcon: Icons.lock,
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Center(
                                      child: Container(
                                    height: 40.h,
                                    width: 235.w,
                                    decoration: BoxDecoration(
                                      color: cGreen,
                                      borderRadius: BorderRadius.circular(36.0),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _updateUserData(
                                              fullName: _fullName.text,
                                              userType: _userType);
                                        }
                                      },
                                      child: btnIsLoading
                                          ? ImageAsset(
                                              imagePath:
                                                  "assets/images/loading.gif",
                                              height: 50.h,
                                              width: 50.w,
                                            )
                                          : Text(
                                              "Edit My Info",
                                              style: GoogleFonts.inter(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: cWhite),
                                            ),
                                    ),
                                  )),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
