import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

class SelectLocationMaps extends StatefulWidget {
  const SelectLocationMaps({Key key}) : super(key: key);

  @override
  _SelectLocationMapsState createState() => _SelectLocationMapsState();
}

class _SelectLocationMapsState extends State<SelectLocationMaps> {
  LatLng _initialcameraposition;
  GoogleMapController _controller;
  Location _location = Location();
  var logger = Logger();
  LocationData _locationData;


  @override
  void initState() {
    super.initState();
    _initialcameraposition = LatLng(11.1271, 78.6569);
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 17),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              // onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        tooltip: "Back",
        child: Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
        mini: true,
        onPressed: () async {
          Navigator.pop(context);
        },
      ),
    );
  }
}
