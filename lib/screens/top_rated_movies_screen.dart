import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/blocs/movie_bloc.dart';
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
            previous.listOfTopRatedMovies != current.listOfTopRatedMovies,
        builder: (context, state) {
          if (state.isGridView) {
            return BuildGridView(listOfMovies: state.listOfTopRatedMovies);
          }
          return BuildListView(listOfMovies: state.listOfTopRatedMovies);
        },
      ),
    );
  }
}
