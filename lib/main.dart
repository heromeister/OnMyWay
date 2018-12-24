import 'package:flutter/material.dart';
import 'onmyway_page.dart';
//import 'cards_onmyway_page.dart';
import 'package:map_view/map_view.dart';
import 'package:easy_alert/easy_alert.dart';

void main() {
  MapView.setApiKey("AIzaSyBboX99l_hmy8E6V4TuaFK8FBM6uBs37kg");
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