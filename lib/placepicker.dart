import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'location_handler.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:latlong/latlong.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

TextEditingController _addressSearchController = new TextEditingController();
String _addressPicked;
bool _addressProccessed = false;

class LocationPickerPage extends StatefulWidget {
  final contact;

  LocationPickerPage({Key key, this.contact}) : super(key: key) {
    print("Place picker's passed contact");
    print(this.contact);
  }

  LocationPickerPageState createState() => new LocationPickerPageState();
}

class LocationPickerPageState extends State<LocationPickerPage> {
  Map<String, double> _userLocation;

  @override
  initState() {
    super.initState();
    getCurrentLocation();

    print("widget.contact: " + widget.contact.toString());
    _addressSearchController.clear();
    if (widget.contact?.address != null) {
      _addressSearchController.text = widget.contact?.address.toString();
    }
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

  currentLocationPressed() async {
    await getCurrentLocation();
    LatLng currentLocation = LatLng(_userLocation["latitude"], _userLocation["longitude"]);
    Navigator.pop(context, {"address": null, "location": currentLocation});
  }

  chooseOnMapPressed() {

  }

  buildDefaultSection(IconData icon, String text, callback) {
    return InkWell(
        onTap: callback,
        child:
        Container(
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(icon, color: Theme.of(context).primaryColor),
                    Padding(padding: EdgeInsets.only(right: 15.0)),
                    Text(text, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18))
                  ],
                )
            ),
            padding: EdgeInsets.only(bottom: 25.0, top: 25.0),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black26)))
        )
    );
  }

  Widget buildCurrentLocationSection() {
    return buildDefaultSection(Icons.near_me, "Your current location", currentLocationPressed);
  }

  Widget buildChooseOnMapSection() {
    return buildDefaultSection(Icons.map, "Choose on map", chooseOnMapPressed);
  }

  Widget buildPickAnAddressSection() {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 5,
                child: TextField(
                  autofocus: true,
                  controller: _addressSearchController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                    icon: Icon(Icons.place),
                    labelText: "Pick an address"
                  )
                )
            ),
            Padding(padding: EdgeInsets.only(right: 10.0)),
            Flexible(
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Padding(child: Icon(Icons.save, color: Colors.white), padding: EdgeInsets.only(top: 17.0, bottom: 17.0)),
                  onPressed: saveAddressLocation,
                )
            )
          ]
      ),
      padding: EdgeInsets.only(top: 25.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text("Location Picker")),
      body: Padding(
          padding: EdgeInsets.only(left: 18.0, right: 18.0),
          child: Column(
            children: [
              buildCurrentLocationSection(),
              buildChooseOnMapSection(),
              Flexible(
                  child: buildPickAnAddressSection()
              )
            ]
          )
        )
    );
  }

  saveAddressLocation() async {
    LocationHandler handler = new LocationHandler();
    _addressPicked = _addressSearchController.text;
    setState(() => _addressProccessed = true);
    try {
      var location = await handler.getAddressLocation(_addressPicked);
      setState(() => _addressProccessed = false);
      print("Address picked " + _addressPicked);
      _addressSearchController.clear();
      Navigator.pop(context, {"address": _addressPicked, "location": location});
    } on StateError catch (e) {
      Alert.alert(context, title: globals.Errors.PlaceNotFound);
    } catch (e) {
      Alert.confirm(context,
          title: globals.Errors.Unexpected + "\nError: " + e.toString());
    } finally {
      setState(() => _addressProccessed = false);
    }
  }
}