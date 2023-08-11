import 'package:flutter/material.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class BuildListView extends StatelessWidget {
  const BuildListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 20,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            // TODO : Implement this
          },
          title: CustomText(
            text: 'Movie Name',
            fontSize: 15.sp,
          ),
        );
      },
    );
  }
}
