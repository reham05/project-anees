import 'package:anees/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/build_setting_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              Center(
                  child: Text(
                "Settings",
                style: GoogleFonts.aclonica(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                    color: Colors.black),
              )),
              SizedBox(
                height: 50.h,
              ),
              BuildSettingItem(
                onTap: () {},
                icon: Icons.person_outlined,
                title: "Account",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () {},
                icon: Icons.notifications_outlined,
                title: "Notifications",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () {},
                icon: Icons.translate_rounded,
                title: "Change Language",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () {},
                icon: Icons.description_outlined,
                title: "Terms & Conditions",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () {},
                icon: Icons.lock_outlined,
                title: "Privacy Policy",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () {},
                icon: Icons.info_outline,
                title: "About",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () {},
                icon: Icons.logout,
                title: "Logout",
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
