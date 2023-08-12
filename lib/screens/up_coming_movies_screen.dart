import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/blocs/movie_bloc.dart';
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
          if (state.isGridView) {
            return BuildGridView(listOfMovies: state.listOfUpcomingMovies);
          }
          return BuildListView(listOfMovies: state.listOfUpcomingMovies);
        },
      ),
    );
  }
}
