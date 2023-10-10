// ignore_for_file: depend_on_referenced_packages

import 'package:json_annotation/json_annotation.dart';

part 'genre_model.g.dart';

// Movie API response
@JsonSerializable()
class GenreModel {
  final int id;
  final String name;
  bool selected;

  GenreModel({
    required this.id,
    required this.name,
    this.selected = false,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenreModelToJson(this);

  static List<GenreModel> convertJsonToGenreModelList({
    required Map<String, dynamic> jsonData,
  }) {
    List<dynamic> genreList = jsonData['genres'];
    List<GenreModel> listOfGenreModels =
        genreList.map((json) => GenreModel.fromJson(json)).toList();
    return listOfGenreModels;
  }

  static List<GenreModel> convertListOfIdsToGenreModel({
    required List<int> genreIds,
  }) {
    return [];
  }
}
