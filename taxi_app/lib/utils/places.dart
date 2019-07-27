import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:taxi_app/models/location_model.dart';

const kGoogleApiKey = "AIzaSyCbX4_MT9fmxe7e40GYXIzXWr_DYaNOlYc";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
Future<LocationModel> getPlace(BuildContext context) async {
  Prediction prediction = await PlacesAutocomplete.show(
    context: context,
    apiKey: kGoogleApiKey,
    mode: Mode.fullscreen, // Mode.fullscreen
    language: "en",
  );
  return getPlacesResult(prediction);
}

Future<LocationModel> getPlacesResult(Prediction prediction) async {
  if (prediction != null) {
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    return LocationModel(
        address: prediction.description, location: LatLng(lat, lng));
  }
  return LocationModel(address: '', location: LatLng(0.0, 0.0));
}
