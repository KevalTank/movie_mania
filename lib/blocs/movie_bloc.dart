import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/constants/api_constants.dart';
import 'package:movie_mania/constants/enums.dart';
import 'package:movie_mania/local_storage/shared_pref_helper.dart';
import 'package:movie_mania/models/movie/movie.dart';
import 'package:movie_mania/repository/app_repository.dart';

part 'movie_event.dart';

part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc({
    required AppRepository appRepository,
    required SharedPrefHelper prefHelper,
  })  : _appRepository = appRepository,
        _prefHelper = prefHelper,
        super(const MovieState()) {
    on<ChangeGridViewToListViewRequested>(_onChangeGridViewToListViewRequested);
    on<ChangeTabBarStatusRequested>(_onChangeTabBarStatusRequested);
    on<LoadPopularMoviesRequested>(_onLoadPopularMovieRequested);
    on<LoadTopRatedMoviesRequested>(_onLoadTopRatedMoviesRequested);
    on<LoadUpcomingMoviesRequested>(_onLoadUpcomingMoviesRequested);
  }

  final AppRepository _appRepository;
  final SharedPrefHelper _prefHelper;

  int popularMoviesCurrentPage = 1;
  int topRatedMoviesCurrentPage = 1;
  int upComingMoviesCurrentPage = 1;

  int totalPagesForPopularMovies = 10;
  int totalPagesForTopRatedMovies = 10;
  int totalPagesForUpComingMovies = 10;

  List<Movie> _popularMoviesList = [];
  List<Movie> _topRatedMoviesList = [];
  List<Movie> _upComingMoviesList = [];

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
    debugPrint(
        'Before fetching API response current page value for the popular movies = $popularMoviesCurrentPage');
    if (event.loadInitialPage ?? false) {
      popularMoviesCurrentPage = 1;
      debugPrint(
          'First time fetching API response current page value for the popular movies = $popularMoviesCurrentPage');
    }
    if (popularMoviesCurrentPage >= totalPagesForPopularMovies) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: 'You have reached to the end of the list',
        ),
      );
    } else {
      var moviesResponse = await _appRepository.loadMovies(
        endPoint: ApiConstants.popular,
        page: popularMoviesCurrentPage,
      );
      if (moviesResponse != null) {
        if (event.loadInitialPage ?? false) {
          _popularMoviesList = [];
        }
        _popularMoviesList.addAll(moviesResponse.results);
        totalPagesForPopularMovies = moviesResponse.totalPages;
        emit(
          state.copyWith(
            status: Status.success,
            listOfPopularMovies: _popularMoviesList,
          ),
        );
        popularMoviesCurrentPage++;
        debugPrint(
            'After fetching API response current page value for the popular movies = $popularMoviesCurrentPage');
      } else {
        emit(
          state.copyWith(
              status: Status.failure,
              errorMessage:
                  'Something went wrong while loading popular movies'),
        );
      }
    }
  }

  FutureOr<void> _onLoadTopRatedMoviesRequested(
    LoadTopRatedMoviesRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: Status.inProgress));
    debugPrint(
        'Before fetching API response current page value for the top rated movies = $topRatedMoviesCurrentPage');
    if (event.loadInitialPage ?? false) {
      topRatedMoviesCurrentPage = 1;
      debugPrint(
          'First time fetching API response current page value for the top rated movies = $topRatedMoviesCurrentPage');
    }
    if (topRatedMoviesCurrentPage >= totalPagesForTopRatedMovies) {
      emit(
        state.copyWith(
            status: Status.failure,
            errorMessage: 'You have reached to the end of the list'),
      );
    } else {
      var moviesResponse = await _appRepository.loadMovies(
        endPoint: ApiConstants.topRated,
        page: topRatedMoviesCurrentPage,
      );
      if (moviesResponse != null) {
        if (event.loadInitialPage ?? false) {
          _topRatedMoviesList = [];
        }
        _topRatedMoviesList.addAll(moviesResponse.results);
        totalPagesForTopRatedMovies = moviesResponse.totalPages;
        emit(
          state.copyWith(
            status: Status.success,
            listOfTopRatedMovies: _topRatedMoviesList,
          ),
        );
        topRatedMoviesCurrentPage++;
        debugPrint(
            'After fetching API response current page value for the top rated movies = $topRatedMoviesCurrentPage');
      } else {
        emit(
          state.copyWith(
              status: Status.failure,
              errorMessage:
                  'Something went wrong while loading top rated movies'),
        );
      }
    }
  }

  FutureOr<void> _onLoadUpcomingMoviesRequested(
    LoadUpcomingMoviesRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: Status.inProgress));
    debugPrint(
        'Before fetching API response current page value for the upcoming movies = $upComingMoviesCurrentPage');
    if (event.loadInitialPage ?? false) {
      upComingMoviesCurrentPage = 1;
      debugPrint(
          'First time fetching API response current page value for the upcoming movies = $upComingMoviesCurrentPage');
    }
    if (upComingMoviesCurrentPage >= totalPagesForUpComingMovies) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: 'You have reached to the end of the list',
        ),
      );
    } else {
      var moviesResponse = await _appRepository.loadMovies(
        endPoint: ApiConstants.upcoming,
        page: upComingMoviesCurrentPage,
      );
      if (moviesResponse != null) {
        if (event.loadInitialPage ?? false) {
          _upComingMoviesList = [];
        }
        _upComingMoviesList.addAll(moviesResponse.results);
        totalPagesForUpComingMovies = moviesResponse.totalPages;
        emit(
          state.copyWith(
            status: Status.success,
            listOfUpcomingMovies: _upComingMoviesList,
          ),
        );
        upComingMoviesCurrentPage++;
        debugPrint(
            'After fetching API response current page value for the upcoming movies = $upComingMoviesCurrentPage');
      } else {
        emit(
          state.copyWith(
              status: Status.failure,
              errorMessage:
                  'Something went wrong while loading upcoming movies'),
        );
      }
    }
  }
}
