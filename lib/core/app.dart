import 'package:flutter/material.dart';
import 'package:task/pages/my_progress_bar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(child: MyProgressBar()),
      ),
    );
  }
}
