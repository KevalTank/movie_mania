import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/blocs/home_bloc.dart';
import 'package:movie_mania/screens/home_screen.dart';
import 'package:sizer/sizer.dart';

class MovieMania extends StatelessWidget {
  const MovieMania({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
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
