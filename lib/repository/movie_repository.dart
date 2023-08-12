part of 'app_repository.dart';

extension MovieRepository on AppRepository {
  Future<MovieResponse?> loadMovies({
    required String endPoint,
    required int page,
  }) async {
    try {
      final updatedEndPoint = '$endPoint?language=en-US&page=$page';
      final popularMoviesResponse = await _dioHttpService.get(updatedEndPoint);
      debugPrint(
          'Response for the popular movies = ${popularMoviesResponse.toString()}');
      var popularMovies = MovieResponse.fromJson(popularMoviesResponse);
      return popularMovies;
    } catch (e) {
      debugPrint('Something went wrong while loading popular movies');
      return null;
    }
  }
}
