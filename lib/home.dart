import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Marker> markers = <Marker>[];
  late Completer<GoogleMapController> _comtroller;
  late LocationData currentLocation;
  LatLng initialcameraposition = LatLng(16.246684095346502, 103.25197508465824);

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
      return await location.getLocation();
    }
  }

  Future _goToMe() async {
    final GoogleMapController controller = await _comtroller.future;
    currentLocation = await getCurrentLocation();
    initialcameraposition = currentLocation as LatLng;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(initialcameraposition.latitude, initialcameraposition.longitude),
            zoom: 16,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Getting Location Point"),
        ),
        body: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _comtroller.complete(controller);
          },
          initialCameraPosition: CameraPosition(
              target: initialcameraposition,
              zoom: 5
          ),
          markers: Set<Marker>.of(markers),
          mapType: MapType.normal,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 40),
          child: FloatingActionButton(
            onPressed: _goToMe,
            child: Icon(Icons.accessibility_new),
          ),
        ),
      ),
    );
  }
}
