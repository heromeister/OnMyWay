import 'package:flutter/material.dart';
import 'onmyway_page.dart';
import 'package:easy_alert/easy_alert.dart';

void main() {
  runApp(AlertProvider(
    child: App(),
    config: AlertConfig(ok: "Confirm", cancel: "Cancel"),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "On My Way",
      theme: ThemeData(
        primaryColor: Colors.indigo,
        //brightness: Brightness.dark
      ),
      home: OnMyWayPage()
    );
  }
}