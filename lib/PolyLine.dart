import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'NetworkHelper.dart';

class myApp extends StatefulWidget {

  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {

  late GoogleMapController mapController;

  final List<LatLng> polyPoints = [];
  final Set<Polyline> polyLines = {};
  List<Marker> markers = <Marker>[];
  var data;

  LatLng start = const LatLng(16.249237503471164, 103.25005265867213);
  LatLng end = const LatLng(16.239770738725504, 103.25682021214791);
  @override
  void initState() {
    super.initState();

    getJsonData();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Polyline Demo'),
          backgroundColor: Colors.blueAccent[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: const LatLng(16.249237503471164, 103.25005265867213),
            zoom: 15,
          ),
          markers: Set<Marker>.of(markers),
          polylines: polyLines,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setMarkers();
  }

  setMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId('Home'),
        position: start,
        infoWindow: InfoWindow(
          title: "Home",
          snippet: "Home Sweet Home",
        ),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId("Destination"),
        position: end,
        infoWindow: InfoWindow(
          title: "Masjid",
          snippet: "5 start ratted place",
        ),
      ),
    );
    setState(() {});
  }

  setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.lightBlue,
      points: polyPoints,
    );
    polyLines.add(polyline);
    setState(() {});
  }

  void getJsonData() async {
    print("555555");
    NetworkHelper network = NetworkHelper(
      startLat: start.latitude,
      startLng: start.longitude,
      endLat: end.latitude,
      endLng: end.longitude);

    try {
      data = await network.getData();
      print("**********************");
      LineString ls =
      LineString(data['features'][0]['geometry']['coordinates']);
      for (int i =0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }
      if (polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }
    } catch (e) {
      print(e);
    }
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
