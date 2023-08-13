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
    on<UserSearchMovieRequested>(_onUserSearchMovieRequested);
    on<ApplyFilterRequested>(_onApplyFilterRequested);
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

  List<Movie> _searchPopularMoviesList = [];
  List<Movie> _searchTopRatedMoviesList = [];
  List<Movie> _searchUpComingMoviesList = [];

  List<int> _genreListForPopularMovies = [];
  List<int> _genreListForTopRatedMovies = [];
  List<int> _genreListForUpComingMovies = [];

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
    add(UserSearchMovieRequested(movieName: event.movieName));
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
      _genreListForPopularMovies = [];
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
        for (int i = 0; i < _popularMoviesList.length; i++) {
          if (_popularMoviesList[i].genreIds.isNotEmpty) {
            _genreListForPopularMovies.addAll(_popularMoviesList[i].genreIds);
          }
        }
        debugPrint(
            'Length of the genre id == ${_genreListForPopularMovies.length}');
        debugPrint(
            'Before calling to set on list ----------- ${_genreListForPopularMovies.length}');
        _genreListForPopularMovies =
            _genreListForPopularMovies.toSet().toList();
        debugPrint(
            'After calling to set on list ----------- ${_genreListForPopularMovies.length}');
        emit(
          state.copyWith(
            status: Status.success,
            listOfPopularMovies: _popularMoviesList,
            genreIdsForPopular: _genreListForPopularMovies,
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
      _genreListForTopRatedMovies = [];
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
        for (int i = 0; i < _topRatedMoviesList.length; i++) {
          if (_topRatedMoviesList[i].genreIds.isNotEmpty) {
            _genreListForTopRatedMovies.addAll(_topRatedMoviesList[i].genreIds);
          }
        }
        _genreListForTopRatedMovies =
            _genreListForTopRatedMovies.toSet().toList();
        emit(
          state.copyWith(
            status: Status.success,
            listOfTopRatedMovies: _topRatedMoviesList,
            genreIdsForTopRated: _genreListForTopRatedMovies,
          ),
        );
        topRatedMoviesCurrentPage++;
        // await _prefHelper.saveMoviesToPreferencesRequested(
        //   listOfMovies: _topRatedMoviesList,
        //   collectionName: SharedPreferencesConstants.topRatedMovies,
        // );
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
      _genreListForUpComingMovies = [];
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
        for (int i = 0; i < _upComingMoviesList.length; i++) {
          if (_upComingMoviesList[i].genreIds.isNotEmpty) {
            _genreListForUpComingMovies.addAll(_upComingMoviesList[i].genreIds);
          }
        }
        _genreListForUpComingMovies =
            _genreListForUpComingMovies.toSet().toList();
        emit(
          state.copyWith(
            status: Status.success,
            listOfUpcomingMovies: _upComingMoviesList,
            genreIdsForUpComing: _genreListForUpComingMovies,
          ),
        );
        upComingMoviesCurrentPage++;
        // await _prefHelper.saveMoviesToPreferencesRequested(
        //   listOfMovies: _upComingMoviesList,
        //   collectionName: SharedPreferencesConstants.upComingMovies,
        // );
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

  FutureOr<void> _onUserSearchMovieRequested(
    UserSearchMovieRequested event,
    Emitter<MovieState> emit,
  ) {
    if (state.tabBarStatus.popular) {
      if (event.movieName.isNotEmpty) {
        _searchPopularMoviesList = [..._popularMoviesList]
            .where((movie) => movie.title
                .toLowerCase()
                .contains(event.movieName.toLowerCase()))
            .toList();
        emit(
          state.copyWith(
            status: Status.success,
            listOfPopularMovies: _searchPopularMoviesList,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: Status.success,
            listOfPopularMovies: _popularMoviesList,
          ),
        );
      }
    } else if (state.tabBarStatus.topRated) {
      if (event.movieName.isNotEmpty) {
        _searchTopRatedMoviesList = [..._topRatedMoviesList]
            .where((movie) => movie.title
                .toLowerCase()
                .contains(event.movieName.toLowerCase()))
            .toList();
        emit(
          state.copyWith(
            status: Status.success,
            listOfTopRatedMovies: _searchTopRatedMoviesList,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: Status.success,
            listOfTopRatedMovies: _topRatedMoviesList,
          ),
        );
      }
    } else {
      if (event.movieName.isNotEmpty) {
        _searchUpComingMoviesList = [..._upComingMoviesList]
            .where((movie) => movie.title
                .toLowerCase()
                .contains(event.movieName.toLowerCase()))
            .toList();
        emit(
          state.copyWith(
            status: Status.success,
            listOfUpcomingMovies: _searchUpComingMoviesList,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: Status.success,
            listOfUpcomingMovies: _upComingMoviesList,
          ),
        );
      }
    }
  }

  FutureOr<void> _onApplyFilterRequested(
    ApplyFilterRequested event,
    Emitter<MovieState> emit,
  ) {
    if (event.filter.isNotEmpty || event.filter != '') {
      if (state.tabBarStatus.popular) {
        List<Movie> filteredMovieList = filterMovies(
            filterType: event.filter, movieList: _popularMoviesList);
        debugPrint(
            'Length of the filtered movies == ${filteredMovieList.length}');
        emit(
          state.copyWith(
            status: Status.success,
            listOfPopularMovies: filteredMovieList,
          ),
        );
      } else if (state.tabBarStatus.topRated) {
        List<Movie> filteredMovieList = filterMovies(
            filterType: event.filter, movieList: _topRatedMoviesList);
        debugPrint(
            'Length of the filtered movies == ${filteredMovieList.length}');
        emit(
          state.copyWith(
            status: Status.success,
            listOfTopRatedMovies: filteredMovieList,
          ),
        );
      } else {
        List<Movie> filteredMovieList = filterMovies(
            filterType: event.filter, movieList: _upComingMoviesList);
        debugPrint(
            'Length of the filtered movies == ${filteredMovieList.length}');
        emit(
          state.copyWith(
            status: Status.success,
            listOfUpcomingMovies: filteredMovieList,
          ),
        );
      }
    } else {
      if (state.tabBarStatus.popular) {
        emit(
          state.copyWith(
            status: Status.success,
            listOfPopularMovies: _popularMoviesList,
          ),
        );
      } else if (state.tabBarStatus.topRated) {
        emit(
          state.copyWith(
            status: Status.success,
            listOfTopRatedMovies: _topRatedMoviesList,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: Status.success,
            listOfUpcomingMovies: _upComingMoviesList,
          ),
        );
      }
    }
  }

  List<Movie> filterMovies({
    required List<Movie> movieList,
    required filterType,
  }) {
    List<Movie> filteredMovieList = [];
    for (final movie in movieList) {
      for (final genreId in movie.genreIds) {
        if (filterType == genreId.toString()) {
          filteredMovieList.add(movie);
        }
      }
    }
    return filteredMovieList;
  }
}
