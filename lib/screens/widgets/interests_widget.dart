import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors.dart';

class InterestsWidget extends StatelessWidget {
  const InterestsWidget({
    super.key,
    this.image,
    this.text,
    required this.isSelected,
    required this.onChanged,
  });

  final String? image;
  final String? text;
  final bool isSelected;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        width: double.infinity,
        height: 80.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(image!),
            fit: BoxFit.cover,
          ),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  text!,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Transform.scale(
                scale: 1.2,
                child: Radio(
                  activeColor: cWhite,
                  value: isSelected,
                  groupValue: true,
                  onChanged: (value) {
                    onChanged();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
