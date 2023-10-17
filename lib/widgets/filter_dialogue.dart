import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/blocs/movie_bloc.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:movie_mania/constants/app_strings.dart';
import 'package:movie_mania/models/genre/genre_model.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:movie_mania/widgets/gap.dart';
import 'package:sizer/sizer.dart';

// Filter dialogue
Future<void> filterDialogue({
  required BuildContext context,
}) async {
  await showDialog(
    context: context,
    builder: (ctx) {
      final alertBoxFilter = ImageFilter.blur(sigmaX: 10, sigmaY: 10);
      var listOfGenreModels = context.read<MovieBloc>().state.listOfGenreModel;
      List<GenreModel> listOfSelectedGenre = [];
      return BackdropFilter(
        filter: alertBoxFilter,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.sp),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Gap(),
                        const CustomText(text: AppStrings.selectGenres),
                        Gap(height: 1.h),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.sp),
                            border: Border.all(width: 0.5.sp),
                          ),
                          child: SizedBox(
                            height: 40.h,
                            width: 100.w,
                            child: ListView.builder(
                              itemCount: listOfGenreModels.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final genre = listOfGenreModels[index];
                                return BuildListTile(
                                  onTap: () {
                                    setState(() {
                                      genre.selected = !genre.selected;
                                      if (genre.selected) {
                                        listOfSelectedGenre.add(genre);
                                      } else {
                                        listOfSelectedGenre.remove(genre);
                                      }
                                    });
                                  },
                                  genreModel: genre,
                                  selected: genre.selected,
                                );
                              },
                            ),
                          ),
                        ),
                        Gap(height: 1.h),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Clear selected genres
                                for (int i = 0;
                                    i < listOfGenreModels.length;
                                    i++) {
                                  listOfGenreModels[i].selected = false;
                                }
                                setState(() {});
                                context.read<MovieBloc>().add(
                                      const ApplyFilterRequested(
                                          filterList: []),
                                    );
                                Navigator.of(context).pop();
                              },
                              child: const CustomText(
                                text: AppStrings.clearFilters,
                              ),
                            ),
                            const Gap(),
                            ElevatedButton(
                              onPressed: () {
                                context.read<MovieBloc>().add(
                                      ApplyFilterRequested(
                                          filterList: listOfSelectedGenre),
                                    );
                                Navigator.of(context).pop();
                              },
                              child: const CustomText(text: AppStrings.apply),
                            ),
                          ],
                        ),
                        const Gap(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class BuildListTile extends StatelessWidget {
  const BuildListTile({
    super.key,
    required this.selected,
    required this.genreModel,
    required this.onTap,
  });

  final bool selected;
  final GenreModel genreModel;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: selected
          ? const Icon(
              Icons.check_outlined,
              color: AppColors.blackColor,
            )
          : const SizedBox.shrink(),
      title: CustomText(text: genreModel.name),
      onTap: onTap,
    );
  }
}
