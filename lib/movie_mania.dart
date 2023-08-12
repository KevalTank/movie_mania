import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/blocs/movie_bloc.dart';
import 'package:movie_mania/configurations/configure_dependencies.dart';
import 'package:movie_mania/local_storage/shared_pref_helper.dart';
import 'package:movie_mania/repository/app_repository.dart';
import 'package:movie_mania/screens/home_screen.dart';
import 'package:sizer/sizer.dart';

class MovieMania extends StatelessWidget {
  MovieMania({super.key});

  final _appRepository = getIt.get<AppRepository>();
  final _prefHelper = getIt.get<SharedPrefHelper>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MovieBloc(appRepository: _appRepository, prefHelper: _prefHelper)
                ..add(const LoadPopularMoviesRequested())
                ..add(const LoadTopRatedMoviesRequested())
                ..add(const LoadUpcomingMoviesRequested()),
          lazy: false,
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'Movie Mania',
            theme: ThemeData.light(useMaterial3: true),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
