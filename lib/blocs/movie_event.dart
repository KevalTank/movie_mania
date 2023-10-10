part of 'movie_bloc.dart';

// Main movie event
class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

// Change gridview to list view
class ChangeGridViewToListViewRequested extends MovieEvent {
  const ChangeGridViewToListViewRequested({
    required this.isGridView,
  });

  final bool isGridView;
}

// Change tab bar status
class ChangeTabBarStatusRequested extends MovieEvent {
  const ChangeTabBarStatusRequested({
    required this.tabBarStatus,
    required this.movieName,
  });

  final TabBarStatus tabBarStatus;
  final String movieName;
}

// Load popular movies
class LoadPopularMoviesRequested extends MovieEvent {
  const LoadPopularMoviesRequested({
    this.loadInitialPage,
  });

  final bool? loadInitialPage;
}

// Load top rated movies
class LoadTopRatedMoviesRequested extends MovieEvent {
  const LoadTopRatedMoviesRequested({
    this.loadInitialPage,
  });

  final bool? loadInitialPage;
}

// Load upcoming movies
class LoadUpcomingMoviesRequested extends MovieEvent {
  const LoadUpcomingMoviesRequested({
    this.loadInitialPage,
  });

  final bool? loadInitialPage;
}

// Search movie
class UserSearchMovieRequested extends MovieEvent {
  const UserSearchMovieRequested({
    required this.movieName,
  });

  final String movieName;
}

// Apply filters
class ApplyFilterRequested extends MovieEvent {
  const ApplyFilterRequested({
    required this.filterList,
  });

  final List<GenreModel> filterList;
}

// Get Genres
class GetGenresRequested extends MovieEvent {
  const GetGenresRequested();
}

// Check network connectivity
class CheckNetworkConnectivity extends MovieEvent {
  const CheckNetworkConnectivity();
}

// Update connectivity status
class UpdateConnectivityStatusRequested extends MovieEvent {
  const UpdateConnectivityStatusRequested({
    required this.connected,
  });

  final bool connected;
}
