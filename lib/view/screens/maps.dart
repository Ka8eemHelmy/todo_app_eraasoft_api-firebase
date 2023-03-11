import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  MapsScreen({Key? key}) : super(key: key);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final Marker marker = Marker(
    markerId: MarkerId('0'),
    position: LatLng(
      37.785834,
      -122.406417,
    ),
    infoWindow: InfoWindow(title: 'markerIdVal', snippet: '*'),
  );


  LocationPermission? permission;

  @override
  void initState() {
    super.initState();
    initGetCurrentPosition();
  }

  Position? currentPosition;

  void initGetCurrentPosition() async {
    currentPosition = await GeolocatorPlatform.instance
        .getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    print('latitude -> ${currentPosition?.latitude ?? 0}');
    print('longitude -> ${currentPosition?.longitude ?? 0}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            currentPosition?.latitude ?? 0,
            currentPosition?.longitude ?? 0,
          ),
          zoom: 10,
        ),
        markers: <Marker>{
          Marker(
              markerId: MarkerId("home"),
              position: LatLng(currentPosition?.latitude ?? 0, currentPosition?.longitude ?? 0),
              infoWindow: InfoWindow(title: "Kareem"),
              // draggable: true,
              // onDragEnd: (newPosition) {
              //   setState(() {
              //     currentPosition = newPosition;
              //     print(currentPosition);
              //   });
              // },
          ),
        },
      ),
    );
  }
}
