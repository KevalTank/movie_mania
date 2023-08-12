import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:movie_mania/models/movie/movie.dart';
import 'package:movie_mania/widgets/custom_text.dart';
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
    _scrollController.addListener(() => _scrollListener());
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.onEndReached();
    }
  }

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
            // TODO : Implement this
            Fluttertoast.showToast(msg: 'Coming soon');
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
