import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/mapProvider.dart';
import 'package:food_for_all/providers/registerDetailsProvider.dart';
import 'package:food_for_all/screens/map.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// ignore: must_be_immutable
class RegisterDetails extends StatefulWidget {
  String title;
  bool edit;

  RegisterDetails({this.title, this.edit});

  @override
  _RegisterDetailsState createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  var latitude, longitude;
  var _address;
  var first;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    await Location().getLocation().then((value) => {
          setState(() {
            latitude = value.latitude;
            longitude = value.longitude;
            loading = true;
          })
        });
    _address = await Geocoder.local
        .findAddressesFromCoordinates(Coordinates(latitude, longitude));
    first = _address.first;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _organizationController = TextEditingController();

    final _formKey = GlobalKey<FormState>();
    return Consumer(
      builder: (context, watch, child) {
        final map = watch(addressProvider);
        final phone = watch(registerProvider).phone;
        final role = watch(registerProvider).role;
        final orgName = watch(registerProvider).orgName;
        final reg = watch(registerDetailsProvider);
        final theme = watch(themingNotifer);
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'images/About.png',
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ),
                    Container(
                      child: role == "Organization"
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                              child: TextFormField(
                                maxLength: 150,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Organization Name",
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.corporate_fare_rounded,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.darkTheme
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.darkTheme
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                                cursorColor: Theme.of(context).primaryColor,
                                controller: _organizationController,
                                style: TextStyle(
                                  color: theme.darkTheme
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                validator: (val) {
                                  if (val.isEmpty) return "Should not be empty";

                                  return null;
                                },
                                onChanged: (val) {
                                  context
                                      .read(registerProvider)
                                      .listenToRegisterDetailsOrgNotifier(
                                        _organizationController.text,
                                      );
                                },
                              ),
                            )
                          : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: ListTile(
                        leading: IconButton(
                          tooltip: "Save your location",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectLocationMaps(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.add_location_alt_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                        ),
                        title: Text(
                          map.address == ""
                              ? loading
                                  ? "Fetching your location"
                                  : first.addressLine
                              : map.address.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                theme.darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: TextFormField(
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Mobile number",
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          prefixIcon: Icon(
                            Icons.phone_android_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  theme.darkTheme ? Colors.black : Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  theme.darkTheme ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        controller: _phoneController,
                        style: TextStyle(
                          color: theme.darkTheme ? Colors.black : Colors.white,
                        ),
                        validator: (val) {
                          if (val.isEmpty) return "Should not be empty";
                          if (val.length < 10)
                            return "Not a valid phone number";
                          return null;
                        },
                        onChanged: (val) {
                          context
                              .read(registerProvider)
                              .listenToRegisterDetailsNotifier(
                                int.parse(_phoneController.text),
                              );
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    ElevatedButton(
                      onPressed: _phoneController.text.length < 10
                          ? null
                          : () {
                              if (_formKey.currentState.validate())
                                widget.edit
                                    ? reg.editRegisterDetails(
                                        context, map.address, map.latLng, phone)
                                    : reg.addRegisterDetails(
                                        context,
                                        first.addressLine ?? map.address,
                                        map.latLng ??
                                            LatLng(latitude, longitude),
                                        phone,
                                        role,
                                        orgName,
                                      );
                            },
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 125),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 20,
                          color: theme.darkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
