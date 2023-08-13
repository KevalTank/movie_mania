import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:movie_mania/models/movie/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class SharedPrefHelper {
  static final SharedPrefHelper _instance = SharedPrefHelper._internal();

  SharedPrefHelper._internal() {
    _initPrefs();
  }

  factory SharedPrefHelper() {
    return _instance;
  }

  SharedPreferences? _prefs;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveMoviesToPreferencesRequested({
    required List<Movie> listOfMovies,
    required String collectionName,
  }) async {
    final List<Map<String, dynamic>> moviesJsonList =
        listOfMovies.map((movie) => movie.toJson()).toList();

    final String moviesJsonString = jsonEncode(moviesJsonList);

    await _prefs?.setString(
      collectionName,
      moviesJsonString,
    );
  }

  Future<List<Movie>> getMoviesListFromPreferencesRequested({
    required String collectionName,
  }) async {
    if (_prefs == null) {
      await _initPrefs();
    }

    final String? moviesJsonString = _prefs?.getString(collectionName);

    if (moviesJsonString == null) {
      return [];
    }

    final List<dynamic> moviesJsonList = jsonDecode(moviesJsonString);

    final List<Movie> listOfMovies =
        moviesJsonList.map((movieJson) => Movie.fromJson(movieJson)).toList();

    return listOfMovies;
  }

  void clear() {
    _prefs?.clear();
  }
}
