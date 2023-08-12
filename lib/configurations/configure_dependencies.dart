import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_mania/configurations/configure_dependencies.config.dart';


final getIt = GetIt.instance;

// Configure the dependencies
@InjectableInit(
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureOrientation();
  getIt.init();
}

// Restrict Orientation
void configureOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
