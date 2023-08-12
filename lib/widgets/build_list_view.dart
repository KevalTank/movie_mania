import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:movie_mania/models/movie/movie.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:movie_mania/widgets/gap.dart';
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
    _scrollController.addListener(() => _scrollListener());
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      debugPrint('List is half scrolled');
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
    return ListView.separated(
      separatorBuilder: (context, index){
        return const Gap();
      },
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: widget.listOfMovies.length,
      padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
      itemBuilder: (context, index) {
        final movie = widget.listOfMovies[index];
        return ListTile(
          onTap: () {
            // TODO : Implement this
            Fluttertoast.showToast(msg: 'Coming soon');
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
