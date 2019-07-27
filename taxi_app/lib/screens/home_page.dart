import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/states/map_provider.dart';
import 'package:taxi_app/utils/constants.dart';
import 'package:taxi_app/utils/style.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Map());
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  static const kGoogleApiKey = "AIzaSyCbX4_MT9fmxe7e40GYXIzXWr_DYaNOlYc";
  GoogleMap initMap(final mapProvider) {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: mapProvider.initialPosition, zoom: 10.0),
      onMapCreated: mapProvider.onCreated,
      mapType: MapType.normal,
      compassEnabled: true,
      markers: mapProvider.markers,
      onCameraMove: mapProvider.onCameraMove,
      polylines: mapProvider.polyLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MapProvider>(context);
    return appState.initialPosition == null
        ? Container(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: <Widget>[
              initMap(appState),
              locationBoxWidget(context, () {
                appState.getPickLocation(context);
              },
                  kTopPickUpPosition,
                  kLeftPosition,
                  kRightPosition,
                  locationListTileWidget(
                      Icons.add_location,
                      Colors.cyanAccent,
                      Colors.cyanAccent,
                      Colors.black,
                      kPickUpText,
                      appState.pickUpLocation)),
              locationBoxWidget(context, () {
                appState.getDropOfLocation(context);
              },
                  kTopDropOfPosition,
                  kLeftPosition,
                  kRightPosition,
                  locationListTileWidget(
                      Icons.pin_drop,
                      Colors.blue,
                      Colors.blue,
                      Colors.grey,
                      kDropOfText,
                      appState.dropOfLocation)),
              bookingWidget(),
            ],
          );
  }
}

Widget locationListTileWidget(IconData leadingIcon, Color leadingIconColor,
    Color titleColor, Color descColor, String titleText, String descText) {
  return ListTile(
    leading: Icon(
      leadingIcon,
      color: leadingIconColor,
    ),
    title: textWidget(titleText, 16.0, FontWeight.bold, titleColor),
    subtitle: textWidget(descText, 14.0, FontWeight.normal, descColor),
  );
}

Widget locationBoxWidget(BuildContext context, Function onPressed, double top,
    double right, double left, Widget tileWidget) {
  return Positioned(
    top: top,
    right: right,
    left: left,
    child: Container(
      height: 65.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(1.0, 5.0),
              blurRadius: 10,
              spreadRadius: 3)
        ],
      ),
      child: InkWell(onTap: onPressed, child: tileWidget),
    ),
  );
}

Widget bookingWidget() {
  return Positioned(
    bottom: kBottomPosition,
    right: kLeftPosition,
    left: kRightPosition,
    child: Container(
      height: 200.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(1.0, 5.0),
              blurRadius: 10,
              spreadRadius: 3)
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                textWidget(kMeteredFare, 16.0, FontWeight.bold, Colors.black),
                Container(
                    width: 150.0,
                    child: textWidget(
                        kFareDesc, 14.0, FontWeight.normal, Colors.grey)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                flatButtonWidget(() {}, kPromo, 12.0, FontWeight.bold,
                    Colors.black, Icons.local_offer),
                flatButtonWidget(() {}, kNotes, 12.0, FontWeight.bold,
                    Colors.black, Icons.create),
                flatButtonWidget(() {}, kCash, 12.0, FontWeight.bold,
                    Colors.black, Icons.credit_card),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 8.0, right: 12.0),
            child: Row(
              children: <Widget>[
                roundedButtonWidget(() {}, Icons.timer),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: buttonWidget(
                        () {}, kBookNow, 18.0, FontWeight.bold, Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
