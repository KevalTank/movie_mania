import 'package:flutter/material.dart';
import 'package:movie_mania/constants/api_constants.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:movie_mania/models/movie/movie.dart';
import 'package:movie_mania/screens/movie_details_screen.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class BuildGridView extends StatefulWidget {
  const BuildGridView({
    super.key,
    required this.listOfMovies,
    required this.onEndReached,
  });

  final List<Movie> listOfMovies;
  final VoidCallback onEndReached;

  @override
  State<BuildGridView> createState() => _BuildGridViewState();
}

class _BuildGridViewState extends State<BuildGridView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Set listener
    _scrollController.addListener(() => _scrollListener());
  }

  void _scrollListener() {
    // Check if list is scrolled till the end if yes then pass the call back
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.onEndReached();
    }
  }

  // Dispose the controller
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      itemCount: widget.listOfMovies.length,
      padding: EdgeInsets.all(10.sp),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 1.5.h,
        mainAxisExtent: 300,
      ),
      itemBuilder: (context, index) {
        final movie = widget.listOfMovies[index];
        return GestureDetector(
          onTap: () {
            // Take to the movie details screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MovieDetailsScreen(movie: movie),
              ),
            );
          },
          child: Stack(
            children: [
              OptimizedCacheImage(
                height: 100.h,
                width: 100.w,
                color: AppColors.whiteColor,
                imageBuilder: (context, imageProvider) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(15.sp),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                imageUrl: '${ApiConstants.movieImagePath}${movie.posterPath}',
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.greyColor[300]!,
                  highlightColor: AppColors.greyColor[100]!,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                  ),
                ),
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 1.h,
                right: 2.w,
                child: CustomText(
                  text: 'Rating ⭐ : ${movie.voteAverage}',
                  textColor: AppColors.whiteColor,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
