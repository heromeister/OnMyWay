import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Welcome!")
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[

          ],
        ),
    );
  }
}

