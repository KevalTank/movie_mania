import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_mania/blocs/movie_bloc.dart';
import 'package:movie_mania/constants/enums.dart';
import 'package:movie_mania/widgets/build_grid_view.dart';
import 'package:movie_mania/widgets/build_list_view.dart';

class PopularMoviesScreen extends StatelessWidget {
  const PopularMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieBloc, MovieState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.isGridView != current.isGridView ||
            previous.listOfPopularMovies != current.listOfPopularMovies,
        builder: (context, state) {
          if (state.status.isFailure) {
            Fluttertoast.showToast(msg: state.errorMessage);
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<MovieBloc>().add(
                    const LoadPopularMoviesRequested(loadInitialPage: true),
                  );
            },
            child: state.isGridView
                ? BuildGridView(
                    listOfMovies: state.listOfPopularMovies,
                    onEndReached: () {
                      debugPrint('End of grid view reached');
                      context
                          .read<MovieBloc>()
                          .add(const LoadPopularMoviesRequested());
                    },
                  )
                : BuildListView(
                    listOfMovies: state.listOfPopularMovies,
                    onEndReached: () {
                      debugPrint('End of list view reached');
                      context
                          .read<MovieBloc>()
                          .add(const LoadPopularMoviesRequested());
                    },
                  ),
          );
        },
      ),
    );
  }
}
