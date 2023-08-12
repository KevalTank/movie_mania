import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/constants/api_constants.dart';
import 'package:movie_mania/constants/enums.dart';
import 'package:movie_mania/models/movie/movie.dart';
import 'package:movie_mania/repository/app_repository.dart';

part 'movie_event.dart';

part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc({
    required AppRepository appRepository,
  })  : _appRepository = appRepository,
        super(const MovieState()) {
    on<ChangeGridViewToListViewRequested>(_onChangeGridViewToListViewRequested);
    on<ChangeTabBarStatusRequested>(_onChangeTabBarStatusRequested);
    on<LoadPopularMoviesRequested>(_onLoadPopularMovieRequested);
    on<LoadTopRatedMoviesRequested>(_onLoadTopRatedMoviesRequested);
    on<LoadUpcomingMoviesRequested>(_onLoadUpcomingMoviesRequested);
  }

  final AppRepository _appRepository;
  final int popularMoviesCurrentPage = 1;
  final int topRatedMoviesCurrentPage = 1;
  final int comingUpMoviesCurrentPage = 1;

  FutureOr<void> _onChangeGridViewToListViewRequested(
    ChangeGridViewToListViewRequested event,
    Emitter<MovieState> emit,
  ) {
    emit(state.copyWith(isGridView: event.isGridView));
  }

  FutureOr<void> _onChangeTabBarStatusRequested(
    ChangeTabBarStatusRequested event,
    Emitter<MovieState> emit,
  ) {
    emit(state.copyWith(tabBarStatus: event.tabBarStatus));
  }

  FutureOr<void> _onLoadPopularMovieRequested(
    LoadPopularMoviesRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: Status.inProgress));
    var moviesResponse = await _appRepository.loadMovies(
      endPoint: ApiConstants.popular,
      page: popularMoviesCurrentPage,
    );
    if (moviesResponse != null) {
      emit(
        state.copyWith(
          status: Status.success,
          listOfPopularMovies: moviesResponse.results,
        ),
      );
    } else {
      emit(
        state.copyWith(
            status: Status.failure,
            errorMessage: 'Something went wrong while loading popular movies'),
      );
    }
  }

  FutureOr<void> _onLoadTopRatedMoviesRequested(
    LoadTopRatedMoviesRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: Status.inProgress));
    var moviesResponse = await _appRepository.loadMovies(
      endPoint: ApiConstants.topRated,
      page: topRatedMoviesCurrentPage,
    );
    if (moviesResponse != null) {
      emit(
        state.copyWith(
          status: Status.success,
          listOfTopRatedMovies: moviesResponse.results,
        ),
      );
    } else {
      emit(
        state.copyWith(
            status: Status.failure,
            errorMessage:
                'Something went wrong while loading top rated movies'),
      );
    }
  }

  FutureOr<void> _onLoadUpcomingMoviesRequested(
    LoadUpcomingMoviesRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: Status.inProgress));
    var moviesResponse = await _appRepository.loadMovies(
      endPoint: ApiConstants.upcoming,
      page: comingUpMoviesCurrentPage,
    );
    if (moviesResponse != null) {
      emit(
        state.copyWith(
          status: Status.success,
          listOfUpcomingMovies: moviesResponse.results,
        ),
      );
    } else {
      emit(
        state.copyWith(
            status: Status.failure,
            errorMessage: 'Something went wrong while loading upcoming movies'),
      );
    }
  }
}
