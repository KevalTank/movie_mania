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

  // Initialize preferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save movie list to the preference
  Future<void> saveMoviesToPreferencesRequested({
    required List<Movie> listOfMovies,
    required String collectionName,
  }) async {
    // Convert movie list to json list
    final List<Map<String, dynamic>> moviesJsonList =
        listOfMovies.map((movie) => movie.toJson()).toList();

    final String moviesJsonString = jsonEncode(moviesJsonList);

    // Store to the preference
    await _prefs?.setString(
      collectionName,
      moviesJsonString,
    );
  }

  // Get movies from the preference
  Future<List<Movie>> getMoviesListFromPreferencesRequested({
    required String collectionName,
  }) async {
    // Check if preference is null then initialize it
    if (_prefs == null) {
      await _initPrefs();
    }

    // Check if data is present in preferences
    final String? moviesJsonString = _prefs?.getString(collectionName);

    // Check for the received data if null then return empty list
    if (moviesJsonString == null) {
      return [];
    }

    // Decode to the object list
    final List<dynamic> moviesJsonList = jsonDecode(moviesJsonString);

    // Convert list to the objects
    final List<Movie> listOfMovies =
        moviesJsonList.map((movieJson) => Movie.fromJson(movieJson)).toList();

    // Return converted list
    return listOfMovies;
  }

  // Clear preferences
  void clear() {
    _prefs?.clear();
  }
}
