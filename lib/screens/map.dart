import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/mapProvider.dart';
import 'package:food_for_all/utils/mapStyle.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

class SelectLocationMaps extends StatefulWidget {
  const SelectLocationMaps({Key key}) : super(key: key);

  @override
  _SelectLocationMapsState createState() => _SelectLocationMapsState();
}

class _SelectLocationMapsState extends State<SelectLocationMaps> {
  LatLng _initialcameraposition, _pinedLocationData;
  GoogleMapController _controller;
  Location _location = Location();
  var logger = Logger();
  LocationData _locationData;
  Marker _pinLocation;
  var _address;

  @override
  void initState() {
    super.initState();
    _modalBottomSheetMenu();
    _initialcameraposition = LatLng(11.1271, 78.6569);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _initialcameraposition,
                    zoom: 15,
                  ),
                  mapType: MapType.normal,
                  onMapCreated: (controller) async {
                    controller.setMapStyle(Utils.mapStyle);
                    _controller = controller;
                    _locationData = await _location.getLocation();
                    _controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                              _locationData.latitude, _locationData.longitude),
                        ),
                      ),
                    );
                  },
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: {
                    if (_pinLocation != null) _pinLocation,
                  },
                  onLongPress: _addMarker,
                  onTap: _removeMarker,
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: Column(
            children: [
              FloatingActionButton(
                tooltip: "Back",
                heroTag: null,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
                mini: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 15,
              ),
              FloatingActionButton(
                tooltip: "Back",
                heroTag: null,
                child: Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
                mini: true,
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  _locationData = await _location.getLocation();
                  _controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                            _locationData.latitude, _locationData.longitude),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _modalBottomSheetMenu() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await showModalBottomSheet(
          context: context,
          builder: (builder) {
            return Container(
              height: 250.0,
              color: Colors.transparent,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0),
                  ),
                ),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Long press on the map to Pin the location 🗺",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Swipe to dismiss",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _addMarker(LatLng pos) async {
    HapticFeedback.mediumImpact();
    if (_pinLocation == null) {
      setState(() {
        _pinedLocationData = pos;
        _pinLocation = Marker(
            markerId: const MarkerId('yourLocation'),
            infoWindow: const InfoWindow(title: "Mark as your location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: pos);
      });
      _address = await Geocoder.local.findAddressesFromCoordinates(Coordinates(
          _pinedLocationData.latitude, _pinedLocationData.longitude));
      var first = _address.first;
      context.read(addressProvider).listenToAddressNotifier(
            first.addressLine,
            LatLng(pos.latitude, pos.longitude),
          );
    }
  }

  void _removeMarker(LatLng pos) {
    HapticFeedback.lightImpact();
    setState(() {
      _pinLocation = null;
      _pinedLocationData = null;
    });
  }
}
