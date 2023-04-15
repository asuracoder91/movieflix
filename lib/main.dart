import 'package:flutter/material.dart';

// main function, Class declaring
void main() {
  runApp(const Movieflix());
}

class Movieflix extends StatelessWidget {
  const Movieflix({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Movieflix',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
