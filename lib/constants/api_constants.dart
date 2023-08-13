// API related constants

class ApiConstants {
  ApiConstants._();

  static const defaultConnectTimeout = Duration(seconds: 60);
  static const defaultReceiveTimeout = Duration(seconds: 60);
  static const apiToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMmVjM2Q2ZjFlYjM5OGM3YjFmMWQ1NmIwMDJlZTYxNyIsInN1YiI6IjY0ZDY5ODk4ZDEwMGI2MDBhZGEwYmI0OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.stCHkVdJdQd4RyMaOl4HO46U2avtl9qLwGKkYouc-SY';

  static const String server = 'https://api.themoviedb.org/3/movie/';

  static const String popular = 'popular';
  static const String topRated = 'top_rated';
  static const String upcoming = 'upcoming';

  static const String movieImagePath = 'https://image.tmdb.org/t/p/w500/';
}
