//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

const String ApiKey = "AIzaSyBH_Eyeh42jgj69vfSCMArchMMrcGPYhhE";

List<SavedContact> ContactsListOnMyWay;

class SavedContact {
  int _id;
  String _identifier;
  String _displayName;
  String _phoneNumber;
  LatLng _location;
  String _address;

  get id => _id;
  get identifier => _identifier;
  get name => _displayName;
  get phone => _phoneNumber;
  get location => _location;
  get address => _address;

  setId(int i) => _id = i;
  setIdentifier(String s) => _identifier = s;
  setName(String n) => _displayName = n;
  setPhone(String p) => _phoneNumber = p;
  setLocation(LatLng l) => _location = l;
  setAddress(String a) => _address = a;

  SavedContact(displayName, phoneNumber, identifier, [address=null, latitude=null, longitude=null, id=null]) {
    _displayName = displayName;
    _phoneNumber = phoneNumber;
    _identifier = identifier;
    if (latitude != null && longitude != null) _location = LatLng(latitude, longitude);
    if (id != null) _id = id;
    if (address != null) _address = address;
  }


  fromMap(Map<String, dynamic> map) {
    _identifier = map["identifier"];
    _displayName = map["displayName"];
    _phoneNumber = map["phoneNumber"];
    _location = LatLng(map["latitude"], map["longitude"]);
    _address = map["address"];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "identifier" : _identifier,
      "displayName": _displayName,
      "phoneNumber": _phoneNumber,
      "latitude": _location?.latitude,
      "longitude": _location?.longitude,
      "address": _address
    };
    return map;
  }

  @override
  String toString() {
    String displayName = this.name;
    String phoneNumber = this.phone;
    String identifier = this.identifier;
    double latitude = this.location?.latitude;
    double longitude = this.location?.longitude;
    int id = this.id;
    String address = this.address;

    print("globals.SavedContact: Id: $id");
    print("globals.SavedContact: Identifier: $identifier");
    print("globals.SavedContact: DisplayName: $displayName");
    print("globals.SavedContact: PhoneNumber: $phoneNumber");
    print("globals.SavedContact: Latitude: $latitude");
    print("globals.SavedContact: Longitude: $longitude");
    print("globals.SavedContact: Address: $address");

    return ("Identifier: $identifier \nDisplay Name: $displayName \nPhone Number: $phoneNumber \nLocation: { latitude: $latitude, longitude: $longitude } \nAddress: $address");
  }
}

class Errors {
  static const String PlaceNotFound = "Location not found. Please review the address and try again.";
  static const String Unexpected = "An unexpected error occurred. Please try again later.";
}

class SharedPrefs {

  static Future<SharedPreferences> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}