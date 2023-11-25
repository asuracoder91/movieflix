import 'package:deviflix/core/core.dart';
import 'package:flutter/material.dart';
import '../../features/home/screens/home_screen.dart';

class Deviflix extends StatelessWidget {
  const Deviflix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deviflix',
      debugShowCheckedModeBanner: false,
      theme: DFTheme.dark,
      home: HomeScreen(),
    );
  }
}
