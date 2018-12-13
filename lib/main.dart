import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "On My Way",
      theme: ThemeData(
        primaryColor: Colors.indigo
      ),
      home: HomePage()
    );
  }
}