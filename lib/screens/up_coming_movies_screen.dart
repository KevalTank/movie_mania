import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_mania/blocs/movie_bloc.dart';
import 'package:movie_mania/constants/enums.dart';
import 'package:movie_mania/widgets/build_grid_view.dart';
import 'package:movie_mania/widgets/build_list_view.dart';

class UpComingMoviesScreen extends StatelessWidget {
  const UpComingMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieBloc, MovieState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.isGridView != current.isGridView ||
            previous.listOfUpcomingMovies != current.listOfUpcomingMovies,
        builder: (context, state) {
          if (state.status.isFailure) {
            Fluttertoast.showToast(msg: state.errorMessage);
          }
          return RefreshIndicator(
            onRefresh: () async {
              // Load up-coming movies
              if (state.connected) {
                context.read<MovieBloc>().add(
                      const LoadUpcomingMoviesRequested(loadInitialPage: true),
                    );
              } else {
                Fluttertoast.showToast(
                    msg: 'To load more movies please connect to the network');
              }
            },
            child: state.isGridView
                ? BuildGridView(
                    listOfMovies: state.listOfUpcomingMovies,
                    onEndReached: () {
                      // Load more movies
                      if (state.connected) {
                        context
                            .read<MovieBloc>()
                            .add(const LoadUpcomingMoviesRequested());
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'To load more movies please connect to the network');
                      }
                    },
                  )
                : BuildListView(
                    listOfMovies: state.listOfUpcomingMovies,
                    onEndReached: () {
                      // Load more movies
                      if (state.connected) {
                        context
                            .read<MovieBloc>()
                            .add(const LoadUpcomingMoviesRequested());
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'To load more movies please connect to the network');
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}
