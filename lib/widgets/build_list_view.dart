import 'package:flutter/material.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:movie_mania/models/movie/movie.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:movie_mania/widgets/gap.dart';
import 'package:sizer/sizer.dart';

class BuildListView extends StatelessWidget {
  const BuildListView({
    super.key,
    required this.listOfMovies,
  });

  final List<Movie> listOfMovies;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index){
        return const Gap();
      },
      shrinkWrap: true,
      itemCount: listOfMovies.length,
      padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
      itemBuilder: (context, index) {
        final movie = listOfMovies[index];
        return ListTile(
          onTap: () {
            // TODO : Implement this
          },
          tileColor: AppColors.greyColor,
          title: CustomText(
            text: movie.title,
            fontSize: 15.sp,
          ),
          trailing: CustomText(text: movie.voteAverage.toString()),
        );
      },
    );
  }
}
