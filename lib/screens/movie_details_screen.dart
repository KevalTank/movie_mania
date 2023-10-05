import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_mania/constants/api_constants.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:movie_mania/models/movie/movie.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:movie_mania/widgets/gap.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: movie.title,
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 2.8/3,
                child: OptimizedCacheImage(
                  fadeInCurve: Curves.bounceInOut,
                  imageBuilder: (context, imageProvider) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                  imageUrl: '${ApiConstants.movieImagePath}${movie.posterPath}',
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppColors.greyColor[300]!,
                    highlightColor: AppColors.greyColor[100]!,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Gap(height: 1.h),
              CustomText(
                text: 'Overview : ',
                fontSize: 14.sp,
                textColor: AppColors.blackColor,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text: movie.overview,
                textColor: AppColors.blackColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
              Gap(height: 1.h),
              BuildMovieInfoWithTitle(
                title: 'Language',
                description: movie.originalLanguage.toUpperCase(),
              ),
              Gap(height: 1.h),
              BuildMovieInfoWithTitle(
                title: 'Vote',
                description: movie.voteCount.toString(),
              ),
              Gap(height: 1.h),
              BuildMovieInfoWithTitle(
                title: 'Rating',
                description: '${movie.voteAverage} :⭐',
              ),
              Gap(height: 1.h),
              BuildMovieInfoWithTitle(
                title: 'Release Date',
                description: movie.releaseDate,
              ),
              const Gap(),
            ],
          ),
        ),
      ),
      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Fluttertoast.showToast(msg: 'Book Ticket');
        },
        child: const Icon(Icons.movie),
      ),
    );
  }
}

// Helper class
class BuildMovieInfoWithTitle extends StatelessWidget {
  const BuildMovieInfoWithTitle({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
          text: '$title : ',
          fontSize: 14.sp,
          textColor: AppColors.blackColor,
          fontWeight: FontWeight.w600,
        ),
        Flexible(
          child: CustomText(
            text: description,
            textColor: AppColors.blackColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
