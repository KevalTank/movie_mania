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
  });

  final TabBarStatus tabBarStatus;
}

class LoadPopularMoviesRequested extends MovieEvent {}

class LoadTopRatedMoviesRequested extends MovieEvent {}

class LoadUpcomingMoviesRequested extends MovieEvent {}
