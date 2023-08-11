import 'package:flutter/material.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.textColor,
    this.fontWeight,
  });

  final String text;
  final double? fontSize;
  final Color? textColor;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 12.sp,
        color: textColor ?? AppColors.blackColor,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
