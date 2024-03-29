import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_mania/blocs/movie_bloc.dart';
import 'package:movie_mania/constants/app_strings.dart';
import 'package:movie_mania/constants/enums.dart';
import 'package:movie_mania/widgets/build_grid_view.dart';
import 'package:movie_mania/widgets/build_list_view.dart';

class TopRatedMoviesScreen extends StatelessWidget {
  const TopRatedMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieBloc, MovieState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.isGridView != current.isGridView ||
            previous.listOfTopRatedMovies != current.listOfTopRatedMovies ||
            previous.connected != current.connected,
        builder: (context, state) {
          if (state.status.isFailure) {
            Fluttertoast.showToast(msg: state.errorMessage);
          }
          return RefreshIndicator(
            onRefresh: () async {
              // Load top rated movies
              if (state.connected) {
                context.read<MovieBloc>().add(
                      const LoadTopRatedMoviesRequested(loadInitialPage: true),
                    );
              } else {
                Fluttertoast.showToast(
                  msg: AppStrings.toLoadMoreMoviesPleaseConnectToTheNetwork,
                );
              }
            },
            child: state.isGridView
                ? BuildGridView(
                    listOfMovies: state.listOfTopRatedMovies,
                    onEndReached: () {
                      // Load more movies
                      if (state.connected) {
                        context
                            .read<MovieBloc>()
                            .add(const LoadTopRatedMoviesRequested());
                      } else {
                        Fluttertoast.showToast(
                          msg: AppStrings
                              .toLoadMoreMoviesPleaseConnectToTheNetwork,
                        );
                      }
                    },
                  )
                : BuildListView(
                    listOfMovies: state.listOfTopRatedMovies,
                    onEndReached: () {
                      // Load more movies
                      if (state.connected) {
                        context
                            .read<MovieBloc>()
                            .add(const LoadTopRatedMoviesRequested());
                      } else {
                        Fluttertoast.showToast(
                          msg: AppStrings
                              .toLoadMoreMoviesPleaseConnectToTheNetwork,
                        );
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}
