import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker _selectedMarker;

class LocationPickerPage extends StatefulWidget {
  final location;
  //LocationPickerPage({this.location});

  LocationPickerPage({Key key, this.location}) : super(key: key) {
    print("Father widget's passed location");
    print(this.location);
  }

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
              print("Location picked " +
                  _selectedMarker.options.position.toString());
              Navigator.pop(context, _selectedMarker.options.position);
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: LocationPicker(locationToDisplay: widget.location),
          ),
        ],
      ),
    );
  }
}

class LocationPicker extends StatefulWidget {
  final locationToDisplay;
  LocationPicker({this.locationToDisplay});

  LocationPickerState createState() => new LocationPickerState();
}

class LocationPickerState extends State<LocationPicker> {
  GoogleMapController controller;
  bool _mapCreated = false;
  Map<String, double> _userLocation;
  bool _isFirstTimePickingLocation;

  @override
  initState() {
    super.initState();
    getCurrentLocation();
    //pullPopupShouldDismiss();
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

  pullPopupShouldDismiss() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTimePickingLocation =
        (prefs.getBool("isFirstTimePickingLocation") ?? true);
    await prefs.setBool("isFirstTimePickingLocation", false);
    _isFirstTimePickingLocation = isFirstTimePickingLocation;
  }

  @override
  Widget build(BuildContext context) {
    //if (_isFirstTimePickingLocation) showAlertDialog(context: context);
    return Column(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              cameraPosition: CameraPosition(
              target: (widget.locationToDisplay != null)
                  ? widget.locationToDisplay
                  : LatLng(_userLocation["latitude"], _userLocation["longitude"]),
              zoom: 15.0,
            ),
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true),
          )
        ),
        Flexible(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      decoration: TextDecoration.underline
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Or enter an address"
                    ),
                  )
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 2.0),
                    width: 10,
                    child: Icon(Icons.edit)
                  )
                )
              ]
            )
          )
        )
      ]
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapCreated = true;
    this.controller = controller;
    controller.onMarkerTapped.add(_onMarkerTapped);

    print("Widget's passed locaiotn: ");
    print(widget.locationToDisplay);
    if (widget.locationToDisplay != null) {
      _addMarker(LatLng(widget.locationToDisplay.latitude,
          widget.locationToDisplay.longitude));
    } else {
      _addMarker(LatLng(_userLocation["latitude"], _userLocation["longitude"]));
    }
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

  void showAlertDialog<T>({BuildContext context}) {
    showDialog<T>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Location Picker"),
              content: Text(
                  "In order to pick a location, long press the marker and drag it around"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Got It!"),
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () {},
                )
              ],
            ));
  }
}
