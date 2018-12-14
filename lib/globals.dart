import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SavedContact {
  int _id;
  String _displayName;
  String _phoneNumber;
  LatLng _location;

  get id => _id;
  get name => _displayName;
  get phone => _phoneNumber;
  get location => _location;

  setId(int i) => _id = i;
  setName(String n) => _displayName = n;
  setPhone(String p) => _phoneNumber = p;
  setLocation(LatLng l) => _location = l;

  SavedContact(displayName, phoneNumber, [id=null, latitude=null, longitude=null]) {
    _displayName = displayName;
    _phoneNumber = phoneNumber;
    if (latitude != null && longitude != null) {
      _location = LatLng(latitude, longitude);
    }
    if (id != null) {
      _id = id;
    }
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
    String displayName = this.name;
    String phoneNumber = this.phone;
    double latitude = this.location?.latitude;
    double longitude = this.location?.longitude;
    int id = this.id;

    print("globals.SavedContact: Id: $id");
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