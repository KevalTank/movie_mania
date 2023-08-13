import 'package:flutter/material.dart';
import 'package:movie_mania/constants/api_constants.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:movie_mania/models/movie/movie.dart';
import 'package:movie_mania/screens/movie_details_screen.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:movie_mania/widgets/gap.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class BuildListView extends StatefulWidget {
  const BuildListView({
    super.key,
    required this.listOfMovies,
    required this.onEndReached,
  });

  final List<Movie> listOfMovies;
  final VoidCallback onEndReached;

  @override
  State<BuildListView> createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
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
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const Gap();
      },
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: widget.listOfMovies.length,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemBuilder: (context, index) {
        final movie = widget.listOfMovies[index];
        return GestureDetector(
          onTap: () {
            // Navigate to the movie details screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MovieDetailsScreen(movie: movie),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.greyColor.shade100,
              borderRadius: BorderRadius.circular(15.sp),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 12.h,
                  width: 20.w,
                  child: Padding(
                    padding: EdgeInsets.all(2.sp),
                    child: OptimizedCacheImage(
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
                      imageUrl:
                          '${ApiConstants.movieImagePath}${movie.posterPath}',
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
                  ),
                ),
                const Gap(),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: movie.title),
                      const Gap(),
                      CustomText(text: 'Rating ⭐ : ${movie.voteAverage}')
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
