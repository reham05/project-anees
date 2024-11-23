import 'dart:io';

import 'package:anees/screens/widgets/txtformfield.dart';
import 'package:anees/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  String? _userImage;
  String? _selectedCity;
  String? _selectedRegion;
  final List<String> _cities = [
    "Riyadh",
    "Jeddah",
    "Dammam",
    "Mecca",
    "Medina"
  ];
  final Map<String, List<String>> _regions = {
    "Riyadh": ["Al Olaya", "Al Malaz", "Al Murabba"],
    "Jeddah": ["Al Hamra", "Al Rawdah", "Al Shate'a"],
    "Dammam": ["Al Faisaliah", "Al Shati Al Gharbi", "Al Mazrouia"],
    "Mecca": ["Al Aziziyah", "Al Mansoor", "Al Shoqiyah"],
    "Medina": ["Al Uyun", "Al Khalidiyah", "Al Qiblatayn"],
  };
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
        _userImage = userData['profile_picture_url'];
        _selectedCity = userData['city'];
        _selectedRegion = userData['region'];
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
            const CropAspectRatio(ratioX: 1, ratioY: 1), 

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
            ratioX: 1, ratioY: 1), 
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
    String? currentUid = FirebaseAuth.instance.currentUser?.uid;

    //**** change user image in posts collection ****/
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    QuerySnapshot snapshot =
        await posts.where('uid', isEqualTo: currentUid).get();

    // Update each post
    for (var doc in snapshot.docs) {
      await doc.reference.update({
        'userImage': downloadURL,
      });
    }
    /************************************** */
    //****************change user image in comments collection ********************/
    CollectionReference postss = FirebaseFirestore.instance.collection('posts');

    // Get all posts
    QuerySnapshot postssSnapshot = await postss.get();

    for (var postDoc in postssSnapshot.docs) {
      // Reference to the comments collection inside the current post
      CollectionReference comments = postDoc.reference.collection('comments');

      // Get all comments in the current post
      QuerySnapshot commentsSnapshot = await comments.get();

      for (var commentDoc in commentsSnapshot.docs) {
        // Update the comment if the uid matches the current user
        if (commentDoc['uid'] == currentUid) {
          await commentDoc.reference.update({
            'userImage': downloadURL,
          });
        }
      }
    }
    /*************************************************************** */

    //****************change user name in feedbacks collection ********************/
    CollectionReference books = FirebaseFirestore.instance.collection('books');

    QuerySnapshot booksSnapshot = await books.get();

    for (var bookDoc in booksSnapshot.docs) {
      // Reference to the feedbacks collection inside the current post
      CollectionReference feedbacks = bookDoc.reference.collection('feedbacks');

      // Get all feedbacks in the current post
      QuerySnapshot feedbacksSnapshot = await feedbacks.get();

      for (var feedbacksDoc in feedbacksSnapshot.docs) {
        // Update the feedbacks if the uid matches the current user
        if (feedbacksDoc['uid'] == currentUid) {
          await feedbacksDoc.reference.update({
            'userImage': downloadURL,
          });
        }
      }
    }
    /************************************************ */
    //**** change user image in chats collection ****/
    CollectionReference chats = FirebaseFirestore.instance.collection('chats');
    QuerySnapshot chatssnapshot =
        await chats.where('reciverId', isEqualTo: currentUid).get();
    // Update each book
    for (var doc in chatssnapshot.docs) {
      await doc.reference.update({
        'reciverImage': downloadURL,
      });
    }
    /*************************************************** */
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

  Future<void> _updateUserData({
    required String fullName,
    required String city,
    required String region,
  }) async {
    setState(() {
      btnIsLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'fullName': fullName,
        'city': city,
        'region': region,
      });
      String? currentUid = FirebaseAuth.instance.currentUser?.uid;
      //**** change user name in posts collection ****/
      CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');
      QuerySnapshot snapshot =
          await posts.where('uid', isEqualTo: currentUid).get();

      // Update each post
      for (var doc in snapshot.docs) {
        await doc.reference.update({
          'fullName': fullName,
        });
      }
      //************************************************************* */
      //****************change user name in comments collection ********************/
      CollectionReference postss =
          FirebaseFirestore.instance.collection('posts');

      // Get all posts
      QuerySnapshot postssSnapshot = await postss.get();

      for (var postDoc in postssSnapshot.docs) {
        // Reference to the comments collection inside the current post
        CollectionReference comments = postDoc.reference.collection('comments');

        // Get all comments in the current post
        QuerySnapshot commentsSnapshot = await comments.get();

        for (var commentDoc in commentsSnapshot.docs) {
          // Update the comment if the uid matches the current user
          if (commentDoc['uid'] == currentUid) {
            await commentDoc.reference.update({
              'fullName': fullName,
            });
          }
        }
      }
      /*************************************************************** */
      //****************change user name in feedbacks collection ********************/
      CollectionReference books =
          FirebaseFirestore.instance.collection('books');

      QuerySnapshot booksSnapshot = await books.get();

      for (var bookDoc in booksSnapshot.docs) {
        // Reference to the feedbacks collection inside the current post
        CollectionReference feedbacks =
            bookDoc.reference.collection('feedbacks');

        // Get all feedbacks in the current post
        QuerySnapshot feedbacksSnapshot = await feedbacks.get();

        for (var feedbacksDoc in feedbacksSnapshot.docs) {
          // Update the feedbacks if the uid matches the current user
          if (feedbacksDoc['uid'] == currentUid) {
            await feedbacksDoc.reference.update({
              'fullName': fullName,
            });
          }
        }
      }
      /************************************************ */
      //**** change user name in books collection ****/
      CollectionReference book = FirebaseFirestore.instance.collection('books');
      QuerySnapshot booksssnapshot =
          await book.where('authorid', isEqualTo: currentUid).get();

      // Update each book
      for (var doc in booksssnapshot.docs) {
        await doc.reference.update({
          'authorName': fullName,
        });
      }
      //**************************************************/

      //**** change user name in chats collection ****/
      CollectionReference chats =
          FirebaseFirestore.instance.collection('chats');
      QuerySnapshot chatssnapshot =
          await chats.where('reciverId', isEqualTo: currentUid).get();
      // Update each book
      for (var doc in chatssnapshot.docs) {
        await doc.reference.update({
          'reciverName': fullName,
        });
      }
      /*************************************************** */
      setState(() {
        _fullName.text = fullName;
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
                                  Text("  City",
                                      style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp)),
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
                                    value: _selectedCity,
                                    hint: const Text("Select city"),
                                    dropdownColor: cWhite,
                                    style: GoogleFonts.inter(
                                        color: cGreen,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400),
                                    items: _cities.map((city) {
                                      return DropdownMenuItem(
                                        value: city,
                                        child: Text(city),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCity = value;
                                        _selectedRegion = null;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 12),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(36.0),
                                        borderSide: const BorderSide(
                                          color: cGrey,
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(36.0),
                                        borderSide: const BorderSide(
                                          color: cGrey,
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(36.0),
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
                                  Text("  Region",
                                      style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp)),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  DropdownButtonFormField<String>(
                                    value: _selectedRegion,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field must not be empty";
                                      }
                                      return null;
                                    },
                                    hint: const Text("Select region"),
                                    style: GoogleFonts.inter(
                                        color: cGreen,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400),
                                    dropdownColor: cWhite,
                                    items: _selectedCity != null
                                        ? _regions[_selectedCity]!
                                            .map((region) {
                                            return DropdownMenuItem(
                                              value: region,
                                              child: Text(region),
                                            );
                                          }).toList()
                                        : [],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedRegion = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 12),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(36.0),
                                        borderSide: const BorderSide(
                                          color: cGrey,
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(36.0),
                                        borderSide: const BorderSide(
                                          color: cGrey,
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(36.0),
                                        borderSide: const BorderSide(
                                          color: cGreen,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
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
                                          
                                              city: _selectedCity!,
                                              region: _selectedRegion!);
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
