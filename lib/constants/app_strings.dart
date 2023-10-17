class AppStrings {
  const AppStrings._();

  static const String keyYouHaveReachedToTheEndOfTheList =
      'You have reached to the end of the list';

  static const String movieMania = 'Movie Mania';
  static const String popular = 'Popular';
  static const String topRated = 'Top Rated';
  static const String upComing = 'Upcoming';

  static const String searchMovies = 'Search movies...';
  static const String overView = 'Overview';
  static const String language = 'Language';
  static const String vote = 'Vote';
  static const String rating = 'Rating';
  static const String releaseDate = 'Release Date';
  static const String bookTicket = 'Book Ticket';
  static const String noImageFound = 'No image found';
  static const String selectGenres = 'Select Genres';
  static const String clearFilters = 'Clear Filter';
  static const String apply = 'Apply';
  static const String toLoadMoreMoviesPleaseConnectToTheNetwork =
      'To load more movies please connect to the network';

  static String keySomethingWentWrongWhileLoadingMovies(
          {required String movies}) =>
      'Something went wrong while loading $movies movies';
}
