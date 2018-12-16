import 'package:flutter/material.dart';
import 'onmyway_page.dart';
import 'package:cirrus_map_view/map_view.dart';

void main() {
  //MapView.setApiKey("AIzaSyBH_Eyeh42jgj69vfSCMArchMMrcGPYhhE");
  runApp(App());
}

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