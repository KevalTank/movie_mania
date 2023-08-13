// API related constants
class ApiConstants {
  ApiConstants._();

  // Time out related
  static const defaultConnectTimeout = Duration(seconds: 60);
  static const defaultReceiveTimeout = Duration(seconds: 60);

  // Token
  static const apiToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMmVjM2Q2ZjFlYjM5OGM3YjFmMWQ1NmIwMDJlZTYxNyIsInN1YiI6IjY0ZDY5ODk4ZDEwMGI2MDBhZGEwYmI0OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.stCHkVdJdQd4RyMaOl4HO46U2avtl9qLwGKkYouc-SY';

  // Main server link
  static const String server = 'https://api.themoviedb.org/3/movie/';

  // End points
  static const String popular = 'popular';
  static const String topRated = 'top_rated';
  static const String upcoming = 'upcoming';

  // For image
  static const String movieImagePath = 'https://image.tmdb.org/t/p/w500/';
}
