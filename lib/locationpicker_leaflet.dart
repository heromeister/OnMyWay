import 'dart:math';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as LocationPackage;
import 'package:flutter_map/flutter_map.dart';

class LeafletLocationPickerPage extends StatelessWidget {
  final location;

  LeafletLocationPickerPage({Key key, this.location}) : super(key: key) {
    print("Father widget's passed location");
    print(this.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Picker"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              //print("Location picked " + _selectedMarker.options.position.toString());
              //Navigator.pop(context, _selectedMarker.options.position);
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: LeafletLocationPicker(locationToDisplay: location),
          ),
        ],
      ),
    );
  }
}


class LeafletLocationPicker extends StatefulWidget {
  final locationToDisplay;
  LeafletLocationPicker({this.locationToDisplay});

  LeafletLocationPickerState createState() => new LeafletLocationPickerState();
}

class LeafletLocationPickerState extends State<LeafletLocationPicker> {
  LatLng _userLocation;
  Point _userCoordinates;

  @override
  initState() {
    super.initState();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    Map<String, double> currentLocation;
    var location = new LocationPackage.Location();

    try {
      currentLocation = await location.getLocation();
    } catch (Exception) {
      currentLocation = null;
    }

    setState(() {
      _userLocation = LatLng(currentLocation["latitude"], currentLocation["longitude"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    double locX, locY;
    const int n = 2 ^ 2;
    if(widget.locationToDisplay != null) {
      locX = n * ((widget.locationToDisplay.longitude + 180) / 360);
      locY = n * (1 - (log(tan(degToRadian(widget.locationToDisplay.latitude)) + 1 / cos(degToRadian(widget.locationToDisplay.latitude)))) / pi) / 2;
    } else {
      locX = n * ((_userLocation.longitude + 180) / 360);
      locY = n * (1 - (log(tan(degToRadian(_userLocation.latitude)) + 1 / cos(degToRadian(_userLocation.latitude)))) / pi) / 2;
    }

    return FlutterMap(
      options: MapOptions(
        center: _userLocation, zoom: 1
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'sk.eyJ1IjoiaGVyb21laXN0ZXIiLCJhIjoiY2pwc21pY3lqMHo5cDN4bXhnYmdhajFpcCJ9.Ej4-fXZnFUH8LTkP6mVfag',
            'id': 'mapbox.streets',
            'z': '2',
            'x': locX.round().toString(),
            'y': locY.round().toString()
          },
        )
      ]
    );
  }
}