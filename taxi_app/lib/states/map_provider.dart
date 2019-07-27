import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_app/models/location_model.dart';
import 'package:taxi_app/requests/google_maps_requests.dart';
import 'package:taxi_app/utils/places.dart';
import 'package:uuid/uuid.dart';

class MapProvider with ChangeNotifier {
  static LatLng _initialPosition;
  static LatLng _destination;
  String _pickUpLocation = '';
  String _dropOfLocation = '';
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng get initialPosition => _initialPosition;
  String get pickUpLocation => _pickUpLocation;
  String get dropOfLocation => _dropOfLocation;
  LatLng get destination => _destination;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;
  LocationModel locationModel = LocationModel();
  static const kZoom = 12.0;
  var location = Location();

  MapProvider() {
    _getUserLocation();
  }
  void getPickLocation(BuildContext context) async {
    locationModel = await getPlace(context);
    _initialPosition = locationModel.location;
    _pickUpLocation = locationModel.address;
    notifyListeners();
  }

  void getDropOfLocation(BuildContext context) async {
    locationModel = await getPlace(context);
    _destination = locationModel.location;
    _dropOfLocation = locationModel.address;
    _mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _initialPosition, zoom: kZoom)));
    sendRequest('');
    notifyListeners();
  }

// ! TO GET THE USERS LOCATION
  void _getUserLocation() async {
    var userLocation = await location.getLocation();
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        userLocation.latitude, userLocation.longitude);
//32.4721419, 74.51855080000001
    _initialPosition = LatLng(userLocation.latitude, userLocation.longitude);
    locationController.text = placemark[0].name;
    notifyListeners();
  }

  // ! TO CREATE ROUTE
  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(Uuid().toString()),
        width: 6,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black));
    notifyListeners();
  }

  // ! ADD A MARKER ON THE MAO
  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(Uuid().toString()),
        position: location,
        infoWindow: InfoWindow(title: address),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // ! SEND REQUEST
  void sendRequest(String intendedLocation) async {
    /* List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;*/
    //LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    createRoute(route);
    notifyListeners();
  }

  // ! ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }
}
