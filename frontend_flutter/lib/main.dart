import 'package:flutter/material.dart';
import 'puzzle_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI 8 Puzzle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PuzzleScreen(),
    );

  }
}