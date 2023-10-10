// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreModel _$GenreModelFromJson(Map<String, dynamic> json) => GenreModel(
      id: json['id'] as int,
      name: json['name'] as String,
      selected: json['selected'] as bool? ?? false,
    );

Map<String, dynamic> _$GenreModelToJson(GenreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'selected': instance.selected,
    };
