import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/blocs/movie_bloc.dart';
import 'package:movie_mania/constants/enums.dart';
import 'package:movie_mania/screens/popular_movies_screen.dart';
import 'package:movie_mania/screens/top_rated_movies_screen.dart';
import 'package:movie_mania/screens/up_coming_movies_screen.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void changeTabRequested({
    required BuildContext context,
    required TabBarStatus tabBarStatus,
  }) {
    context.read<MovieBloc>().add(
          ChangeTabBarStatusRequested(
            tabBarStatus: tabBarStatus,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: 'Movie Mania',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
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
              Tab(icon: Text('Popular')),
              Tab(icon: Text('Top Rated')),
              Tab(icon: Text('Upcoming')),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            PopularMoviesScreen(),
            TopRatedMoviesScreen(),
            UpComingMoviesScreen(),
          ],
        ),
      ),
    );
  }
}
