part of 'movie_bloc.dart';

// State variables
class MovieState extends Equatable {
  const MovieState({
    this.status = Status.initial,
    this.errorMessage = '',
    this.isGridView = true,
    this.tabBarStatus = TabBarStatus.popular,
    this.listOfPopularMovies = const [],
    this.listOfTopRatedMovies = const [],
    this.listOfUpcomingMovies = const [],
    this.genreIdsForPopular = const [],
    this.genreIdsForTopRated = const [],
    this.genreIdsForUpComing = const [],
    this.listOfGenreModel = const [],
    this.connected = false,
  });

  final Status status;
  final String errorMessage;
  final bool isGridView;
  final TabBarStatus tabBarStatus;
  final List<Movie> listOfPopularMovies;
  final List<Movie> listOfTopRatedMovies;
  final List<Movie> listOfUpcomingMovies;
  final List<int> genreIdsForPopular;
  final List<int> genreIdsForTopRated;
  final List<int> genreIdsForUpComing;
  final List<GenreModel> listOfGenreModel;
  final bool connected;

  MovieState copyWith({
    Status? status,
    String? errorMessage,
    bool? isGridView,
    TabBarStatus? tabBarStatus,
    List<Movie>? listOfPopularMovies,
    List<Movie>? listOfTopRatedMovies,
    List<Movie>? listOfUpcomingMovies,
    List<int>? genreIdsForPopular,
    List<int>? genreIdsForTopRated,
    List<int>? genreIdsForUpComing,
    List<GenreModel>? listOfGenreModel,
    bool? connected,
  }) {
    return MovieState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isGridView: isGridView ?? this.isGridView,
      tabBarStatus: tabBarStatus ?? this.tabBarStatus,
      listOfPopularMovies: listOfPopularMovies ?? this.listOfPopularMovies,
      listOfTopRatedMovies: listOfTopRatedMovies ?? this.listOfTopRatedMovies,
      listOfUpcomingMovies: listOfUpcomingMovies ?? this.listOfUpcomingMovies,
      genreIdsForPopular: genreIdsForPopular ?? this.genreIdsForPopular,
      genreIdsForTopRated: genreIdsForTopRated ?? this.genreIdsForTopRated,
      genreIdsForUpComing: genreIdsForUpComing ?? this.genreIdsForUpComing,
      listOfGenreModel: listOfGenreModel ?? this.listOfGenreModel,
      connected: connected ?? this.connected,
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
        genreIdsForPopular,
        genreIdsForTopRated,
        genreIdsForUpComing,
        listOfGenreModel,
        connected,
      ];
}
