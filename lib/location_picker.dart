import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker _selectedMarker;

class LocationPickerPage extends StatefulWidget {
  LocationPickerPageState createState() => new LocationPickerPageState();
}

class LocationPickerPageState extends State<LocationPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Picker"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context, _selectedMarker.options.position);
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: LocationPicker(),
          ),
        ],
      ),
    );
  }
}

class LocationPicker extends StatefulWidget {
  LocationPickerState createState() => new LocationPickerState();
}

class LocationPickerState extends State<LocationPicker> {
  GoogleMapController controller;
  bool _mapCreated = false;
  Map<String, double> _userLocation;

  @override
  initState() {
    super.initState();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    Map<String, double> currentLocation;
    var location = new Location();

    try {
      currentLocation = await location.getLocation();
    } catch (Exception) {
      currentLocation = null;
    }

    setState(() {
      _userLocation = currentLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      options: GoogleMapOptions(
          cameraPosition: CameraPosition(
            target:
                LatLng(_userLocation["latitude"], _userLocation["longitude"]),
            zoom: 15.0,
          ),
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: true),
    ); //: Center(child: CircularProgressIndicator());
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapCreated = true;
    this.controller = controller;
    controller.onMarkerTapped.add(_onMarkerTapped);
    _addMarker(LatLng(_userLocation["latitude"], _userLocation["longitude"]));
  }

  @override
  void dispose() {
    controller?.onMarkerTapped?.remove(_onMarkerTapped);
    super.dispose();
  }

  void _addMarker(LatLng location) async {
    _selectedMarker = await controller.addMarker(MarkerOptions(
        position: location,
        infoWindowText: InfoWindowText('Marker', '*'),
        draggable: true));
  }

  void _onMarkerTapped(Marker marker) {
    if (_selectedMarker != null) {
      _updateSelectedMarker(
        const MarkerOptions(icon: BitmapDescriptor.defaultMarker),
      );
    }
    setState(() {
      _selectedMarker = marker;
    });
    _updateSelectedMarker(
      MarkerOptions(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
      ),
    );
  }

  void _updateSelectedMarker(MarkerOptions changes) {
    controller.updateMarker(_selectedMarker, changes);
  }
}
