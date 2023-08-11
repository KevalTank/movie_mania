import 'package:flutter/material.dart';
import 'package:movie_mania/screens/home_screen.dart';
import 'package:sizer/sizer.dart';

class MovieMania extends StatelessWidget {
  const MovieMania({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'E-Learning App',
          theme: ThemeData.light(useMaterial3: true),
          home: const HomeScreen(),
        );
      },
    );
  }
}
