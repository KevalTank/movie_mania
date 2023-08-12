import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_mania/models/movie_response/movie_response.dart';
import 'package:movie_mania/network/dio_http_service.dart';

part 'movie_repository.dart';

// Main app repository
@singleton
class AppRepository {
  AppRepository(this._dioHttpService);

  final DioHttpService _dioHttpService;
}
