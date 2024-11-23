import 'package:anees/screens/about_app_screen.dart';
import 'package:anees/screens/account_screen.dart';
import 'package:anees/screens/change_password_screen.dart';
import 'package:anees/screens/login_screen.dart';
import 'package:anees/screens/privacy_policy.dart';
import 'package:anees/screens/terms_conditions_screen.dart';
import 'package:anees/utils/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/auth_service.dart';
import 'notification_screen.dart';
import 'widgets/build_setting_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountScreen(),
                      ));
                },
                icon: Icons.person_outlined,
                title: "Account",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(
                          fromHomeScreen: false,
                        ),
                      ));
                },
                icon: Icons.notifications_outlined,
                title: "Notifications",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ));
                },
                icon: Icons.lock_outline,
                title: "Change Password",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsConditionsScreen(),
                      ));
                },
                icon: Icons.description_outlined,
                title: "Terms & Conditions",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ));
                },
                icon: Icons.lock_outlined,
                title: "Privacy Policy",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutAppScreen(),
                      ));
                },
                icon: Icons.info_outline,
                title: "About",
              ),
              const Divider(),
              BuildSettingItem(
                onTap: () async {
                  await _authService.signOut();

                  Navigator.pushAndRemoveUntil(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
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
