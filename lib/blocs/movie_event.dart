part of 'movie_bloc.dart';

class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class ChangeGridViewToListViewRequested extends MovieEvent {
  const ChangeGridViewToListViewRequested({
    required this.isGridView,
  });

  final bool isGridView;
}

class ChangeTabBarStatusRequested extends MovieEvent {
  const ChangeTabBarStatusRequested({
    required this.tabBarStatus,
    required this.movieName,
  });

  final TabBarStatus tabBarStatus;
  final String movieName;
}

class LoadPopularMoviesRequested extends MovieEvent {
  const LoadPopularMoviesRequested({
    this.loadInitialPage,
  });

  final bool? loadInitialPage;
}

class LoadTopRatedMoviesRequested extends MovieEvent {
  const LoadTopRatedMoviesRequested({
    this.loadInitialPage,
  });

  final bool? loadInitialPage;
}

class LoadUpcomingMoviesRequested extends MovieEvent {
  const LoadUpcomingMoviesRequested({
    this.loadInitialPage,
  });

  final bool? loadInitialPage;
}

class UserSearchMovieRequested extends MovieEvent {
  const UserSearchMovieRequested({
    required this.movieName,
  });

  final String movieName;
}

class ApplyFilterRequested extends MovieEvent {
  const ApplyFilterRequested({
    required this.filter,
  });

  final String filter;
}
