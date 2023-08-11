import 'package:flutter/material.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class BuildMovieWidget extends StatelessWidget {
  const BuildMovieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.w,
      height: 5.h,
      color: AppColors.blackColor,
    );
  }
}
