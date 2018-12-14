import 'package:flutter/material.dart';
import 'onmyway_page.dart';
import 'globals.dart' as globals;

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "On My Way",
      theme: ThemeData(
        primaryColor: Colors.indigo
      ),
      home: OnMyWayPage()
    );
  }
}