import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/constants/api_constants.dart';
import 'package:movie_mania/constants/enums.dart';
import 'package:movie_mania/constants/shared_preferences_constants.dart';
import 'package:movie_mania/local_storage/shared_pref_helper.dart';
import 'package:movie_mania/models/genre/genre_model.dart';
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
    on<GetGenresRequested>(_onGetGenresRequested);
  }

  // Created instants
  final AppRepository _appRepository;
  final SharedPrefHelper _prefHelper;

  // Holds the index for calling API
  int popularMoviesCurrentPage = 1;
  int topRatedMoviesCurrentPage = 1;
  int upComingMoviesCurrentPage = 1;

  // Holds the total pages initially given 10
  int totalPagesForPopularMovies = 10;
  int totalPagesForTopRatedMovies = 10;
  int totalPagesForUpComingMovies = 10;

  // Holds the list of the movies based on their categories
  List<Movie> _popularMoviesList = [];
  List<Movie> _topRatedMoviesList = [];
  List<Movie> _upComingMoviesList = [];

  // Holds the list of movies based on user search
  List<Movie> _searchPopularMoviesList = [];
  List<Movie> _searchTopRatedMoviesList = [];
  List<Movie> _searchUpComingMoviesList = [];

  // Holds the list of the genre for the filtration
  List<int> _genreListForPopularMovies = [];
  List<int> _genreListForTopRatedMovies = [];
  List<int> _genreListForUpComingMovies = [];

  // Change the state form grid view to list view
  FutureOr<void> _onChangeGridViewToListViewRequested(
    ChangeGridViewToListViewRequested event,
    Emitter<MovieState> emit,
  ) {
    emit(state.copyWith(isGridView: event.isGridView));
  }

  // Change the tab of the screen
  FutureOr<void> _onChangeTabBarStatusRequested(
    ChangeTabBarStatusRequested event,
    Emitter<MovieState> emit,
  ) {
    emit(state.copyWith(tabBarStatus: event.tabBarStatus));
    add(UserSearchMovieRequested(movieName: event.movieName));
  }

  // Load the popular movies
  FutureOr<void> _onLoadPopularMovieRequested(
    LoadPopularMoviesRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: Status.inProgress));
    // Check in the preferences if list of popular movies is available
    List<Movie> listOfPopularMoviesFromPref =
        await _prefHelper.getMoviesListFromPreferencesRequested(
      collectionName: SharedPreferencesConstants.popularMovies,
    );
    _popularMoviesList = listOfPopularMoviesFromPref;
    // If list of the popular movies is available
    // and its not calling for the first time then return the list from the preferences
    if (listOfPopularMoviesFromPref.isNotEmpty &&
        (event.loadInitialPage ?? false)) {
      // Add the genre ids for the filtration
      for (int i = 0; i < _popularMoviesList.length; i++) {
        if (_popularMoviesList[i].genreIds.isNotEmpty) {
          _genreListForPopularMovies.addAll(_popularMoviesList[i].genreIds);
        }
      }
      // Removed the redundant genre ids from the list
      _genreListForPopularMovies = _genreListForPopularMovies.toSet().toList();
      emit(
        state.copyWith(
          status: Status.success,
          listOfPopularMovies: _popularMoviesList,
          genreIdsForPopular: _genreListForPopularMovies,
        ),
      );
    }
    // Either it is first time or loading more movies
    else {
      // If user refresh/reload the popular movies
      // Then load the first page for the API, and reset the genre list
      if (event.loadInitialPage ?? false) {
        popularMoviesCurrentPage = 1;
        _genreListForPopularMovies = [];
      }
      // Check if the current page index of the popular movies is
      // The limit of the API then show error message
      if (popularMoviesCurrentPage >= totalPagesForPopularMovies) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: 'You have reached to the end of the list',
          ),
        );
      }
      // If goes here that means still user can fetch the movies
      else {
        // Call the API
        var moviesResponse = await _appRepository.loadMovies(
          endPoint: ApiConstants.popular,
          page: popularMoviesCurrentPage,
        );
        // Check if response is not null
        if (moviesResponse != null) {
          // If user has refreshed/reloaded the popular movies list then,
          // First of all set the empty list
          if (event.loadInitialPage ?? false) {
            _popularMoviesList = [];
          }
          // Add the received list of popular movies to the state
          _popularMoviesList.addAll(moviesResponse.results);
          // Set the final and last page number
          totalPagesForPopularMovies = moviesResponse.totalPages;
          // Add the genre ids for the filtration
          for (int i = 0; i < _popularMoviesList.length; i++) {
            if (_popularMoviesList[i].genreIds.isNotEmpty) {
              _genreListForPopularMovies.addAll(_popularMoviesList[i].genreIds);
            }
          }
          // Removed the redundant genre ids from the list
          _genreListForPopularMovies =
              _genreListForPopularMovies.toSet().toList();
          // Save the popular list of popular movies to the preferences
          await _prefHelper.saveMoviesToPreferencesRequested(
            listOfMovies: _popularMoviesList,
            collectionName: SharedPreferencesConstants.popularMovies,
          );
          // Update the state
          emit(
            state.copyWith(
              status: Status.success,
              listOfPopularMovies: _popularMoviesList,
              genreIdsForPopular: _genreListForPopularMovies,
            ),
          );
          // Increment the counter for the next API call
          popularMoviesCurrentPage++;
        }
        // Handled the failure case
        else {
          emit(
            state.copyWith(
              status: Status.failure,
              errorMessage: 'Something went wrong while loading popular movies',
            ),
          );
        }
      }
    }
  }

  // Load the top rated movies
  FutureOr<void> _onLoadTopRatedMoviesRequested(
    LoadTopRatedMoviesRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: Status.inProgress));
    // Check in the preferences if list of top rated movies is available
    List<Movie> listOfTopRatedMoviesFromPref =
        await _prefHelper.getMoviesListFromPreferencesRequested(
      collectionName: SharedPreferencesConstants.topRatedMovies,
    );
    _topRatedMoviesList = listOfTopRatedMoviesFromPref;
    // If list of the top rated movies is available
    // and its not calling for the first time then return the list from the preferences
    if (listOfTopRatedMoviesFromPref.isNotEmpty &&
        (event.loadInitialPage ?? false)) {
      // Add the genre ids for the filtration
      for (int i = 0; i < _topRatedMoviesList.length; i++) {
        if (_topRatedMoviesList[i].genreIds.isNotEmpty) {
          _genreListForTopRatedMovies.addAll(_topRatedMoviesList[i].genreIds);
        }
      }
      // Removed the redundant genre ids from the list
      _genreListForTopRatedMovies =
          _genreListForTopRatedMovies.toSet().toList();
      emit(
        state.copyWith(
          status: Status.success,
          listOfTopRatedMovies: _topRatedMoviesList,
          genreIdsForTopRated: _genreListForTopRatedMovies,
        ),
      );
    }
    // Either it is first time or loading more movies
    else {
      // If user refresh/reload the top rated movies
      // Then load the first page for the API, and reset the genre list
      if (event.loadInitialPage ?? false) {
        topRatedMoviesCurrentPage = 1;
        _genreListForTopRatedMovies = [];
      }
      // Check if the current page index of the top rated movies is
      // The limit of the API then show error message
      if (topRatedMoviesCurrentPage >= totalPagesForTopRatedMovies) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: 'You have reached to the end of the list',
          ),
        );
      }
      // If goes here that means still user can fetch the movies
      else {
        // Call the API
        var moviesResponse = await _appRepository.loadMovies(
          endPoint: ApiConstants.topRated,
          page: topRatedMoviesCurrentPage,
        );
        // Check if response is not null
        if (moviesResponse != null) {
          // If user has refreshed/reloaded the top rated movies list then,
          // First of all set the empty list
          if (event.loadInitialPage ?? false) {
            _topRatedMoviesList = [];
          }
          // Add the received list of top rated movies to the state
          _topRatedMoviesList.addAll(moviesResponse.results);
          // Set the final and last page number
          totalPagesForTopRatedMovies = moviesResponse.totalPages;
          // Add the genre ids for the filtration
          for (int i = 0; i < _topRatedMoviesList.length; i++) {
            if (_topRatedMoviesList[i].genreIds.isNotEmpty) {
              _genreListForTopRatedMovies
                  .addAll(_topRatedMoviesList[i].genreIds);
            }
          }
          // Removed the redundant genre ids from the list
          _genreListForTopRatedMovies =
              _genreListForTopRatedMovies.toSet().toList();
          // Save the popular list of popular movies to the preferences
          await _prefHelper.saveMoviesToPreferencesRequested(
            listOfMovies: _topRatedMoviesList,
            collectionName: SharedPreferencesConstants.topRatedMovies,
          );
          // Update the state
          emit(
            state.copyWith(
              status: Status.success,
              listOfTopRatedMovies: _topRatedMoviesList,
              genreIdsForTopRated: _genreListForTopRatedMovies,
            ),
          );
          // Increment the counter for the next API call
          topRatedMoviesCurrentPage++;
        }
        // Handled the failure case
        else {
          emit(
            state.copyWith(
              status: Status.failure,
              errorMessage:
                  'Something went wrong while loading top rated movies',
            ),
          );
        }
      }
    }
  }

  // Load the up-coming movies
  FutureOr<void> _onLoadUpcomingMoviesRequested(
    LoadUpcomingMoviesRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: Status.inProgress));
    // Check in the preferences if list of up-coming movies is available
    List<Movie> listOfUpComingMoviesFromPref =
        await _prefHelper.getMoviesListFromPreferencesRequested(
      collectionName: SharedPreferencesConstants.upComingMovies,
    );
    _upComingMoviesList = listOfUpComingMoviesFromPref;
    // If list of the up-coming movies is available
    // and its not calling for the first time then return the list from the preferences
    if (listOfUpComingMoviesFromPref.isNotEmpty &&
        (event.loadInitialPage ?? false)) {
      // Add the genre ids for the filtration
      for (int i = 0; i < _upComingMoviesList.length; i++) {
        if (_upComingMoviesList[i].genreIds.isNotEmpty) {
          _genreListForUpComingMovies.addAll(_upComingMoviesList[i].genreIds);
        }
      }
      // Removed the redundant genre ids from the list
      _genreListForUpComingMovies =
          _genreListForUpComingMovies.toSet().toList();
      emit(
        state.copyWith(
          status: Status.success,
          listOfUpcomingMovies: _upComingMoviesList,
          genreIdsForUpComing: _genreListForUpComingMovies,
        ),
      );
    }
    // Either it is first time or loading more movies
    else {
      // If user refresh/reload the top rated movies
      // Then load the first page for the API, and reset the genre list
      if (event.loadInitialPage ?? false) {
        upComingMoviesCurrentPage = 1;
        _genreListForUpComingMovies = [];
      }
      // Check if the current page index of the up-coming movies is
      // The limit of the API then show error message
      if (upComingMoviesCurrentPage >= totalPagesForUpComingMovies) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: 'You have reached to the end of the list',
          ),
        );
      }
      // If goes here that means still user can fetch the movies
      else {
        // Call the API
        var moviesResponse = await _appRepository.loadMovies(
          endPoint: ApiConstants.upcoming,
          page: upComingMoviesCurrentPage,
        );
        // Check if response is not null
        if (moviesResponse != null) {
          // If user has refreshed/reloaded the up-coming movies list then,
          // First of all set the empty list
          if (event.loadInitialPage ?? false) {
            _upComingMoviesList = [];
          }
          // Add the received list of up-coming movies to the state
          _upComingMoviesList.addAll(moviesResponse.results);
          // Set the final and last page number
          totalPagesForUpComingMovies = moviesResponse.totalPages;
          // Add the genre ids for the filtration
          for (int i = 0; i < _upComingMoviesList.length; i++) {
            if (_upComingMoviesList[i].genreIds.isNotEmpty) {
              _genreListForUpComingMovies
                  .addAll(_upComingMoviesList[i].genreIds);
            }
          }
          // Removed the redundant genre ids from the list
          _genreListForUpComingMovies =
              _genreListForUpComingMovies.toSet().toList();
          // Save the popular list of up-coming movies to the preferences
          await _prefHelper.saveMoviesToPreferencesRequested(
            listOfMovies: _upComingMoviesList,
            collectionName: SharedPreferencesConstants.upComingMovies,
          );
          // Update the state
          emit(
            state.copyWith(
              status: Status.success,
              listOfUpcomingMovies: _upComingMoviesList,
              genreIdsForUpComing: _genreListForUpComingMovies,
            ),
          );
          // Increment the counter for the next API call
          upComingMoviesCurrentPage++;
        }
        // Handled the failure case
        else {
          emit(
            state.copyWith(
              status: Status.failure,
              errorMessage:
                  'Something went wrong while loading upcoming movies',
            ),
          );
        }
      }
    }
  }

  // Search movie based on user entered key word
  FutureOr<void> _onUserSearchMovieRequested(
    UserSearchMovieRequested event,
    Emitter<MovieState> emit,
  ) {
    // Check if selected tab bar is popular
    if (state.tabBarStatus.popular) {
      // Check if search text is not empty
      if (event.movieName.isNotEmpty) {
        // Filter the movie based on text
        _searchPopularMoviesList = [..._popularMoviesList]
            .where((movie) => movie.title
                .toLowerCase()
                .contains(event.movieName.toLowerCase()))
            .toList();
        // Update state
        emit(
          state.copyWith(
            status: Status.success,
            listOfPopularMovies: _searchPopularMoviesList,
          ),
        );
      }
      // If goes here that means the search text is empty,
      // So return the popular movie list
      else {
        emit(
          state.copyWith(
            status: Status.success,
            listOfPopularMovies: _popularMoviesList,
          ),
        );
      }
    }
    // Check if selected tab bar is top rated
    else if (state.tabBarStatus.topRated) {
      // Check if search text is not empty
      if (event.movieName.isNotEmpty) {
        // Filter the movie based on text
        _searchTopRatedMoviesList = [..._topRatedMoviesList]
            .where((movie) => movie.title
                .toLowerCase()
                .contains(event.movieName.toLowerCase()))
            .toList();
        // Update state
        emit(
          state.copyWith(
            status: Status.success,
            listOfTopRatedMovies: _searchTopRatedMoviesList,
          ),
        );
      }
      // If goes here that means the search text is empty,
      // So return the top rated movie list
      else {
        emit(
          state.copyWith(
            status: Status.success,
            listOfTopRatedMovies: _topRatedMoviesList,
          ),
        );
      }
    }
    // If goes here that means last option up-coming
    else {
      // Check if search text is not empty
      if (event.movieName.isNotEmpty) {
        // Filter the movie based on text
        _searchUpComingMoviesList = [..._upComingMoviesList]
            .where((movie) => movie.title
                .toLowerCase()
                .contains(event.movieName.toLowerCase()))
            .toList();
        // Update state
        emit(
          state.copyWith(
            status: Status.success,
            listOfUpcomingMovies: _searchUpComingMoviesList,
          ),
        );
      }
      // If goes here that means the search text is empty,
      // So return the up-coming movie list
      else {
        emit(
          state.copyWith(
            status: Status.success,
            listOfUpcomingMovies: _upComingMoviesList,
          ),
        );
      }
    }
  }

  // Filtration
  FutureOr<void> _onApplyFilterRequested(
    ApplyFilterRequested event,
    Emitter<MovieState> emit,
  ) {
    // Check if the applied filter is not empty
    if (event.filter.isNotEmpty || event.filter != '') {
      // Check the tab bar for popular
      if (state.tabBarStatus.popular) {
        // Filter movies based on genre Id
        List<Movie> filteredMovieList = filterMovies(
          filterType: event.filter,
          movieList: _popularMoviesList,
        );
        // Update state
        emit(
          state.copyWith(
            status: Status.success,
            listOfPopularMovies: filteredMovieList,
          ),
        );
      }
      // Check the tab bar for top rated
      else if (state.tabBarStatus.topRated) {
        // Filter movies based on genre Id
        List<Movie> filteredMovieList = filterMovies(
          filterType: event.filter,
          movieList: _topRatedMoviesList,
        );
        // Update state
        emit(
          state.copyWith(
            status: Status.success,
            listOfTopRatedMovies: filteredMovieList,
          ),
        );
      }
      // If goes here that means tab is up-coming
      else {
        // Filter movies
        List<Movie> filteredMovieList = filterMovies(
          filterType: event.filter,
          movieList: _upComingMoviesList,
        );
        // Update state
        emit(
          state.copyWith(
            status: Status.success,
            listOfUpcomingMovies: filteredMovieList,
          ),
        );
      }
    }
    // Handle case for search text is empty
    else {
      // Check tab bar for popular
      if (state.tabBarStatus.popular) {
        // Update state with the whole popular list
        emit(
          state.copyWith(
            status: Status.success,
            listOfPopularMovies: _popularMoviesList,
          ),
        );
      }
      // Check tab bar for top rated
      else if (state.tabBarStatus.topRated) {
        // Update state with whole top rated list
        emit(
          state.copyWith(
            status: Status.success,
            listOfTopRatedMovies: _topRatedMoviesList,
          ),
        );
      }
      // For the up-coming
      else {
        // Update state with whole up-coming list
        emit(
          state.copyWith(
            status: Status.success,
            listOfUpcomingMovies: _upComingMoviesList,
          ),
        );
      }
    }
  }

  // Helper method to filter the movies based on genre id
  List<Movie> filterMovies({
    required List<Movie> movieList,
    required String filterType,
  }) {
    List<Movie> filteredMovieList = [];
    for (final movie in movieList) {
      // Assuming genreIds is a list of genre IDs associated with the movie
      for (final genreId in movie.genreIds) {
        // Find the corresponding GenreModel with the matching id
        final genreModel = state.listOfGenreModel.firstWhere(
          (genre) => genre.id == genreId,
          orElse: () => GenreModel(id: -1, name: ''),
        );
        // Compare filterType with genreModel.name
        if (filterType == genreModel.name) {
          filteredMovieList.add(movie);
        }
      }
    }
    return filteredMovieList;
  }

  FutureOr<void> _onGetGenresRequested(
    GetGenresRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: Status.inProgress));
    final listOfGenres = await _appRepository.getGenresRequested();
    emit(
      state.copyWith(
        status: Status.success,
        listOfGenreModel: listOfGenres,
      ),
    );
  }
}
