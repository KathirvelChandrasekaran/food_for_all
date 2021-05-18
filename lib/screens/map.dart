import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    _initialcameraposition = LatLng(11.1271, 78.6569);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              logger.i(_pinedLocationData);
              HapticFeedback.lightImpact();
              _locationData = await _location.getLocation();
              _controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target:
                        LatLng(_locationData.latitude, _locationData.longitude),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _addMarker(LatLng pos) {
    HapticFeedback.mediumImpact();
    if (_pinLocation == null)
      setState(() {
        _pinedLocationData = pos;
        _pinLocation = Marker(
            markerId: const MarkerId('yourLocation'),
            infoWindow: const InfoWindow(title: "Mark as your location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: pos);
      });
  }

  void _removeMarker(LatLng pos) {
    HapticFeedback.lightImpact();
    setState(() {
      _pinLocation = null;
      _pinedLocationData = null;
    });
  }
}

class Utils {
  static String mapStyle = '''
  [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]
  ''';
}
