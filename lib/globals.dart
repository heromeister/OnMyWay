import 'package:google_maps_flutter/google_maps_flutter.dart';

class SavedContact {
  int _id;
  String _displayName;
  String _phoneNumber;
  double _latitude;
  double _longitude;

  Name() => _displayName;
  PhoneNumber() => _phoneNumber;
  Location() => { "latitude": _latitude, "longitude": _longitude };

  SavedContact(displayName, phoneNumber, [latitude=-1, longitude=-1]);

  setLocation(LatLng location) {
    _latitude = location.latitude;
    _longitude = location.longitude;
  }

  @override
  String toString() {
    return ("Display Name: " + this.Name() +
          "\nPhone Number: " + this.PhoneNumber() +
          "\nLocation: { latitude: " + this.Location()["latitude"] +
                      ", longitude: " + this.Location()["longitude"] +
                      "}");
  }
}