import 'package:flutter/material.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:movie_mania/models/movie/movie.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class BuildGridView extends StatelessWidget {
  const BuildGridView({
    super.key,
    required this.listOfMovies,
  });

  final List<Movie> listOfMovies;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: listOfMovies.length,
      padding: EdgeInsets.all(10.sp),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 1.5.h,
        mainAxisExtent: 300,
      ),
      itemBuilder: (context, index) {
        final movie = listOfMovies[index];
        return GestureDetector(
          onTap: () {
            // TODO : Implement this
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.greyColor,
              borderRadius: BorderRadius.circular(15.sp),
            ),
            child: Center(
              child: CustomText(
                text: movie.title,
                fontSize: 15.sp,
                textColor: AppColors.blackColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
