import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SavedContact {
  int _id;
  String _displayName;
  String _phoneNumber;
  LatLng _location;

  Name() => _displayName;
  PhoneNumber() => _phoneNumber;
  Location() => _location;

  SavedContact(displayName, phoneNumber, [latitude=null, longitude=null]) {
    _displayName = displayName;
    _phoneNumber = phoneNumber;
    if (latitude != null && longitude != null) {
      _location = LatLng(latitude, longitude);
    }
  }

  setLocation(LatLng location) {
    _location = location;
  }

  fromMap(Map<String, dynamic> map) {
    _displayName = map["displayName"];
    _phoneNumber = map["phoneNumber"];
    _location = LatLng(map["latitude"], map["longitude"]);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "displayName": _displayName,
      "phoneNumber": _phoneNumber,
      "latitude": _location.latitude,
      "longitude": _location.longitude
    };
    return map;
  }

  @override
  String toString() {
    String displayName = this.Name();
    String phoneNumber = this.PhoneNumber();
    double latitude = this.Location()?.latitude;
    double longitude = this.Location()?.longitude;

    print("globals.SavedContact: DisplayName: $displayName");
    print("globals.SavedContact: PhoneNumber: $phoneNumber");
    print("globals.SavedContact: Latitude: $latitude");
    print("globals.SavedContact: Longitude: $longitude");

    return ("Display Name: $displayName \nPhone Number: $phoneNumber \nLocation: { latitude: $latitude, longitude: $longitude }");
  }
}

class SharedPrefs {

  static Future<SharedPreferences> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}