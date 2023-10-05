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
      debugPrint(
          'Something went wrong while loading popular movies -- ${e.toString()}');
      return null;
    }
  }

  // Load Genres
  Future<List<GenreModel>> getGenresRequested() async {
    try {
      final genreResponse = await _dioHttpService.get(ApiConstants.getGenres);
      var response = GenreModel.convertJsonToGenreModelList(jsonData: genreResponse);
      return response;
    } catch (e) {
      debugPrint(
          'Something went wrong while loading the genres -- ${e.toString()}');
      return [];
    }
  }
}
