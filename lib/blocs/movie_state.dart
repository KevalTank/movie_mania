part of 'movie_bloc.dart';

class MovieState extends Equatable {
  const MovieState({
    this.status = Status.initial,
    this.errorMessage = '',
    this.isGridView = true,
    this.tabBarStatus = TabBarStatus.popular,
    this.listOfPopularMovies = const [],
    this.listOfTopRatedMovies = const [],
    this.listOfUpcomingMovies = const [],
  });

  final Status status;
  final String errorMessage;
  final bool isGridView;
  final TabBarStatus tabBarStatus;
  final List<Movie> listOfPopularMovies;
  final List<Movie> listOfTopRatedMovies;
  final List<Movie> listOfUpcomingMovies;

  MovieState copyWith({
    Status? status,
    String? errorMessage,
    bool? isGridView,
    TabBarStatus? tabBarStatus,
    List<Movie>? listOfPopularMovies,
    List<Movie>? listOfTopRatedMovies,
    List<Movie>? listOfUpcomingMovies,
  }) {
    return MovieState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isGridView: isGridView ?? this.isGridView,
      tabBarStatus: tabBarStatus ?? this.tabBarStatus,
      listOfPopularMovies: listOfPopularMovies ?? this.listOfPopularMovies,
      listOfTopRatedMovies: listOfTopRatedMovies ?? this.listOfTopRatedMovies,
      listOfUpcomingMovies: listOfUpcomingMovies ?? this.listOfUpcomingMovies,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage,
        isGridView,
        tabBarStatus,
        listOfPopularMovies,
        listOfTopRatedMovies,
        listOfUpcomingMovies,
      ];
}
