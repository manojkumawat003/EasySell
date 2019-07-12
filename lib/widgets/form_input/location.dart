import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../models/location.dart';
import '../../models/product.dart';



class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;
  LocationInput(this.setLocation, this.product);
  @override
  State<StatefulWidget> createState() {
    return _LocationInput();
  }
}

class _LocationInput extends State<LocationInput> {
  Completer<GoogleMapController> _controller = Completer();
  bool _showMap = false;

  LocationData _locationData;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if (widget.product != null) {
      _searchAddress(widget.product.location.address, false);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  Future<void> _goToNewLocation(lat, lon) async {
    if (lat == null) {
      return;
    }
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, lon),
        tilt: 59.440717697143555,
        zoom: 15.151926040649414)));
  }

  Widget _googleMap() {
    if (_showMap) {
      return Container(
          width: 500,
          height: 300,
          child: GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            // scrollGesturesEnabled: true,
            //     rotateGesturesEnabled: true,
            //     tiltGesturesEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(
              <Marker>[
                Marker(
                  onTap: () {
                    /* mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(, ))))*/
                  },
                  visible: true,
                  draggable: true,
                  markerId: MarkerId("1"),
                  position:
                      LatLng(_locationData.latitude, _locationData.longitude),
                  icon: BitmapDescriptor.defaultMarker,
                  infoWindow: const InfoWindow(
                    title: 'My Marker',
                  ),
                )
              ],
            ),
          ));
    } else {
      return Container();
    }
  }

  Future<void> _searchAddress(String value, [geoCode = true]) async {
    if (value.isEmpty) {
      setState(() {
        _showMap = false;
      });
      widget.setLocation(null);
      return;
    }

    if (geoCode) {
      final http.Response response = await http.get(
          'https://us1.locationiq.com/v1/search.php?key=14dbce366cc616&q=$value&format=json');
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 404) {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Entered incorrect address!'),
                content: Text('Please enter valid address.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }

      final decodedResponse = await json.decode(response.body);

      _locationData = LocationData(
          latitude: double.parse(decodedResponse[0]['lat']),
          longitude: double.parse(decodedResponse[0]['lon']),
          address: decodedResponse[0]['display_name']);
    } else {
      _locationData = widget.product.location;
    }
    widget.setLocation(_locationData);

    if (_locationData.latitude == null) {
      setState(() {
        _showMap = false;
      });
      return;
    } else {
      setState(() {
        _showMap = true;
      });
    }

    print(_locationData);

    await _goToNewLocation(_locationData.latitude, _locationData.longitude);
    if (mounted) {
      setState(() {
        _addressInputController.text = _locationData.address;
      }); 
    }
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      _searchAddress(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          focusNode: _addressInputFocusNode,
          controller: _addressInputController,
          validator: (String value) {
            if (_locationData == null || value.isEmpty) {
              return 'No valid location found!';
            }
          },
          decoration: InputDecoration(labelText: 'Address'),
        ),
        SizedBox(
          height: 20.0,
        ),
        // _googleMap(),
        _searchAddress == null ? Container() : _googleMap(),
        // FloatingActionButton.extended(
        //   onPressed: () {
        //     //   _goToTheLake();
        //   },
        //   label: Text('To the lake!'),
        //   icon: Icon(Icons.directions_boat),
        // ),
      ],
    );
  }
}
