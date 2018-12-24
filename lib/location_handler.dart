import 'dart:io';
import 'dart:convert';
import 'package:latlong/latlong.dart';
import 'globals.dart' as globals;
import 'package:latlong/latlong.dart';

class LocationHandler {
  String placesApiUrl = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key={0}&input={1}&inputtype=textquery";
  String placeDetailsApiUrl = "https://maps.googleapis.com/maps/api/place/details/json?key={0}&placeid={1}&fields=geometry";

  getAddressLocation(String address) async {
    String placesUrl = placesApiUrl;
    placesUrl = placesUrl.replaceAll("{0}", globals.ApiKey);
    placesUrl = placesUrl.replaceAll("{1}", address);

    var request = await HttpClient().getUrl(Uri.parse(placesUrl));
    var response = await request.close();

    print("PLACESSSSSSSSSSSSSSSSSSSSSSSSS");
    await for (var contents in response.transform(Utf8Decoder())) {
      print("Place Id query");
      print(contents);
      var placeJson = jsonDecode(contents);

      // place not found check
      if(placeJson != null && placeJson["status"] == "ZERO_RESULTS") {
        throw StateError(globals.Errors.PlaceNotFound);
      }

      // handle place found
      if (placeJson != null &&
          placeJson["candidates"] != null &&
          placeJson["candidates"][0] != null &&
          placeJson["candidates"][0]["place_id"] != null) {

         String placeId = placeJson["candidates"][0]["place_id"];
         String placeDetailsUrl = placeDetailsApiUrl;
         placeDetailsUrl = placeDetailsUrl.replaceAll("{0}", globals.ApiKey);
         placeDetailsUrl = placeDetailsUrl.replaceAll("{1}", placeId);

         print(placeDetailsUrl);
         request = await HttpClient().getUrl(Uri.parse(placeDetailsUrl));
         response = await request.close();

         await for (var contents in response.transform(Utf8Decoder())) {
           print("Place details query");
           print(contents);

           var placeDetailsJson = jsonDecode(contents);
           if (placeDetailsJson != null &&
               placeDetailsJson["result"] != null &&
               placeDetailsJson["result"]["geometry"] != null &&
               placeDetailsJson["result"]["geometry"]["location"] != null) {

              var location = placeDetailsJson["result"]["geometry"]["location"];
              return LatLng(location["lat"], location["lng"]);
           }
         }
      }
    }

    return "error";
  }
}