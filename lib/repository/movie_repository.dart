part of 'app_repository.dart';

// Extension of app repository
extension MovieRepository on AppRepository {
  // Load movies
  Future<MovieResponse?> loadMovies({
    required String endPoint,
    required int page,
  }) async {
    try {
      final updatedEndPoint = '$endPoint?language=en-US&page=$page';
      final popularMoviesResponse = await _dioHttpService.get(updatedEndPoint);
      var popularMovies = MovieResponse.fromJson(popularMoviesResponse);
      return popularMovies;
    } catch (e) {
      debugPrint('Something went wrong while loading popular movies -- ${e.toString()}');
      return null;
    }
  }
}
