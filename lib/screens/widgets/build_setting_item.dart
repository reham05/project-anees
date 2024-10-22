import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildSettingItem extends StatelessWidget {
  const BuildSettingItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});
  final IconData? icon;
  final String? title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 25.h,
      leading: Icon(
        icon,
        size: 23.sp,
      ),
      title: Text(
        title!,
        style: TextStyle(
          fontSize: 16.sp,
          fontFamily: "Nizar",
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
      onTap: onTap,
    );
  }
}
