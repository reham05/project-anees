import 'package:anees/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventdetailsScreen extends StatefulWidget {
  const EventdetailsScreen({super.key, required this.eventdetails});
  // ignore: prefer_typing_uninitialized_variables
  final eventdetails;
  @override
  State<EventdetailsScreen> createState() => _EventdetailsScreenState();
}

class _EventdetailsScreenState extends State<EventdetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      appBar: AppBar(
        backgroundColor: cGreen,
        title: Text(
          "Details",
          style: GoogleFonts.aclonica(
              color: cWhite, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: cWhite,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 80.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                        color: cGreen,
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.eventdetails['institutionImage']),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Institution Name:",
                          style: GoogleFonts.inter(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp),
                        ),
                        Text(
                          widget.eventdetails['institutionName'],
                          style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Event Title:",
                style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp),
              ),
              Text(
                widget.eventdetails['eventTitle'],
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp),
              ),
              Text(
                "Event Date:",
                style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp),
              ),
              Text(
                DateFormat('d-M-yyyy').format(
                  DateTime.parse(widget.eventdetails['eventDate']),
                ),
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp),
              ),
              Text(
                "City:",
                style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp),
              ),
              Text(
                widget.eventdetails['city'],
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp),
              ),
              Text(
                "Region:",
                style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp),
              ),
              Text(
                widget.eventdetails['region'],
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp),
              ),
              Text(
                "Address:",
                style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp),
              ),
              Text(
                widget.eventdetails['address'],
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp),
              ),
                 Text(
                "Language:",
                style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp),
              ),
              Text(
                widget.eventdetails['langauge'],
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp),
              ),
              Text(
                "Event Details:",
                style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp),
              ),
              Text(
                widget.eventdetails['eventDetails'],
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp),
              ),
           
            ],
          ),
        ),
      ),
    );
  }
}
