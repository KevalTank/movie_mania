import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/blocs/movie_bloc.dart';
import 'package:movie_mania/constants/app_colors.dart';
import 'package:movie_mania/constants/app_strings.dart';
import 'package:movie_mania/constants/enums.dart';
import 'package:movie_mania/screens/popular_movies_screen.dart';
import 'package:movie_mania/screens/top_rated_movies_screen.dart';
import 'package:movie_mania/screens/up_coming_movies_screen.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:movie_mania/widgets/filter_dialogue.dart';
import 'package:movie_mania/widgets/unfocus_wrapper.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  void changeTabRequested({
    required BuildContext context,
    required TabBarStatus tabBarStatus,
  }) {
    // Change tab bar
    context.read<MovieBloc>().add(
          ChangeTabBarStatusRequested(
            tabBarStatus: tabBarStatus,
            movieName: searchController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: UnFocusWrapper(
        child: Scaffold(
          appBar: AppBar(
            title: CustomText(
              text: 'Movie Mania',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Row(
                  children: [
                    const CustomText(
                      text: 'GridView',
                      fontWeight: FontWeight.w600,
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: context.watch<MovieBloc>().state.isGridView,
                        onChanged: (bool isGridView) {
                          // Change view
                          context.read<MovieBloc>().add(
                                ChangeGridViewToListViewRequested(
                                  isGridView: isGridView,
                                ),
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
            bottom: TabBar(
              onTap: (int tabIndex) {
                switch (tabIndex) {
                  case 0:
                    changeTabRequested(
                      context: context,
                      tabBarStatus: TabBarStatus.popular,
                    );
                    break;
                  case 1:
                    changeTabRequested(
                      context: context,
                      tabBarStatus: TabBarStatus.topRated,
                    );
                    break;
                  case 2:
                    changeTabRequested(
                      context: context,
                      tabBarStatus: TabBarStatus.upcoming,
                    );
                    break;
                  default:
                    changeTabRequested(
                      context: context,
                      tabBarStatus: TabBarStatus.popular,
                    );
                    break;
                }
              },
              tabs: const [
                Tab(icon: Text(AppStrings.popular)),
                Tab(icon: Text(AppStrings.topRated)),
                Tab(icon: Text(AppStrings.upComing)),
              ],
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: searchController,
                        onChanged: (String movieName) {
                          // Search movie
                          context.read<MovieBloc>().add(
                                UserSearchMovieRequested(movieName: movieName),
                              );
                        },
                        decoration: InputDecoration(
                          hintText: AppStrings.searchMovies,
                          hintStyle:
                              const TextStyle(color: AppColors.blackColor),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: AppColors.whiteColor,
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    // Clear text from the text field
                                    searchController.clear();
                                    // Get all the movies
                                    context.read<MovieBloc>().add(
                                          const UserSearchMovieRequested(
                                              movieName: ''),
                                        );
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Filter dialog
                        filterDialogue(context: context);
                      },
                      padding: EdgeInsets.all(10.sp),
                      icon: const Icon(Icons.filter_alt_rounded),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    PopularMoviesScreen(),
                    TopRatedMoviesScreen(),
                    UpComingMoviesScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
