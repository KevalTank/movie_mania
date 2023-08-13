import 'package:flutter/material.dart';
import 'package:movie_mania/configurations/configure_dependencies.dart';
import 'package:movie_mania/movie_mania.dart';

void main() async {
  // Configures the dependencies
  await configureDependencies();
  runApp(MovieMania());
}
