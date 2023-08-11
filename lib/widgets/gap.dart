import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Gap extends StatelessWidget {
  const Gap({
    super.key,
    this.height,
    this.width,
  });

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 2.h,
      width: width ?? 4.w,
    );
  }
}
