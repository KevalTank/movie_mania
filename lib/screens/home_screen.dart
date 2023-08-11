import 'package:flutter/material.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Movie Mania',
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                const CustomText(
                  text: 'GridView',
                  fontWeight: FontWeight.w600,
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: enabled,
                    onChanged: (bool enable) {
                      setState(() {
                        enabled = !enabled;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      body: enabled
          ? GridView.builder(
              itemCount: 10,
              padding: EdgeInsets.all(10.sp),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 1.5.h,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    child: Center(
                      child: CustomText(
                        text: 'Movie Name',
                        fontSize: 15.sp,
                        textColor: AppColors.blackColor,
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: 20,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  title: CustomText(
                    text: 'Movie Name',
                    fontSize: 15.sp,
                  ),
                );
              },
            ),
    );
  }
}
