import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';
import '../utils/image_util.dart';
import 'upload_personal_image_screen.dart';

class UserRoleSelectionPage extends StatefulWidget {
  const UserRoleSelectionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserRoleSelectionPageState createState() => _UserRoleSelectionPageState();
}

class _UserRoleSelectionPageState extends State<UserRoleSelectionPage> {
  final _formKey = GlobalKey<FormState>();
  bool btnIsLoading = false;
  String _userRole = 'Author';
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  void _saveUserRole({required String city, required String region}) async {
    setState(() {
      btnIsLoading = true;
    });
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'userType': _userRole,
          'city': city,
          'region': region,
        });

        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const UploadPersonalImageScreen(),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No user logged in',
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AbsorbPointer(
        absorbing: btnIsLoading,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: cGreen,
            title: Text(
              'Complete account creation',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold, fontSize: 16.sp, color: cWhite),
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "  You are..",
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp),
                  ),
                  SizedBox(height: 10.h),
                  RadioListTile<String>(
                    activeColor: cGreen3,
                    title: Text(
                      'Author',
                      style: GoogleFonts.inter(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                    value: 'Author',
                    groupValue: _userRole,
                    onChanged: (value) {
                      setState(() {
                        _userRole = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    activeColor: cGreen3,
                    title: Text(
                      'Reader',
                      style: GoogleFonts.inter(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                    value: 'Reader',
                    groupValue: _userRole,
                    onChanged: (value) {
                      setState(() {
                        _userRole = value!;
                      });
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
                        ? _regions[_selectedCity]!.map((region) {
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
                  SizedBox(height: 20.h),
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
                          _saveUserRole(
                              city: _selectedCity!, region: _selectedRegion!);
                        }
                      },
                      child: btnIsLoading
                          ? ImageAsset(
                              imagePath: "assets/images/loading.gif",
                              height: 50.h,
                              width: 50.w,
                            )
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
    );
  }
}
