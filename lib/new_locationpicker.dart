import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as LocationPackage;
import 'package:map_view/map_view.dart';

class NewLocationPickerPage extends StatelessWidget {
  final location;

  NewLocationPickerPage({Key key, this.location}) : super(key: key) {
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
            child: NewLocationPicker(locationToDisplay: location),
          ),
        ],
      ),
    );
  }
}


class NewLocationPicker extends StatefulWidget {
  final locationToDisplay;
  NewLocationPicker({this.locationToDisplay});

  NewLocationPickerState createState() => new NewLocationPickerState();
}

class NewLocationPickerState extends State<NewLocationPicker> {
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  Map<String, double> _userLocation;
  StaticMapProvider staticMapProvider = new StaticMapProvider("AIzaSyBH_Eyeh42jgj69vfSCMArchMMrcGPYhhE");
  Uri staticMapUri;

  @override
  initState() {
    super.initState();

    MapView mapView = new MapView();
    getCurrentLocation();
    Map<String, double> fromMap = _userLocation;
    if (widget.locationToDisplay != null) {
      Map<String, double> map = new Map();
      map["latitude"] = widget.locationToDisplay.latitude;
      map["longitude"] = widget.locationToDisplay.longitude;
      fromMap = map;
    }
    fromMap["zoom"] = 15.0;
    fromMap["bearing"] = 0;
    fromMap["tilt"] = 0;
    cameraPosition = new CameraPosition.fromMap(fromMap);

    staticMapUri = staticMapProvider.getStaticUri(Location.fromMap(fromMap), 15, width: 900, height: 400, mapType: StaticMapViewType.roadmap);

    mapView.onMapTapped.listen((location) {
      mapView.setMarkers(<Marker>[
          new Marker("1", "Picked Place", location.latitude, location.longitude),
      ]);
    });

    mapView.onCameraChanged.listen((cameraPosition) {
        this.setState(() => this.cameraPosition = cameraPosition);
    });
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
      _userLocation = currentLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Map View Example'),
      ),
      body: InkWell(
        child: Center(
          child: Image.network(staticMapUri.toString()),
          ),
        onTap: showMap
      )
    );
  }

  showMap() {
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            showMyLocationButton: true,
            initialCameraPosition: cameraPosition,
            hideToolbar: true));

    mapView.addMarker(new Marker("1", "Current Location", cameraPosition.center.latitude, cameraPosition.center.longitude));
  }
}

