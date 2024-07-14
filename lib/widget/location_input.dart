import 'dart:convert';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:favorite_places/models/place.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as geocoding;

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key,required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

  PlaceLocation? _pickedLocation;
  var _isGettingLocation=false;

  // String get locationImage{
  //   if(_pickedLocation==null){
  //     return'';
  //   }
  //   final lat=_pickedLocation!.latitude;
  //   final lng=_pickedLocation!.longitude;
  //   return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap &markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyA0CKDFl9Qg4WuDPLslph39BDHH1_z5psI';
  // }

  void _getCurrentLocation() async {


    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation=true;
    });

    locationData = await location.getLocation();
    final lat=locationData.latitude;
    final lng=locationData.longitude;
    print(lat.toString());
    print(lng.toString());

    if(lat==null||lng==null){
      const snackBar0 = SnackBar(
        content: Text('No latitude longitude selected'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar0);
      return;
    }


    // final url=Uri.parse(
    //     'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyA0CKDFl9Qg4WuDPLslph39BDHH1_z5psI');
    // final response=await http.get(url);
    // final resData=json.decode(response.body);
    List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(lat, lng);
    final address=placemarks.reversed.last.street.toString()+" , "+placemarks.reversed.last.locality.toString()+" , "+placemarks.reversed.last.administrativeArea.toString()+" , "+placemarks.reversed.last.country.toString();
    print(address);
      setState(() {
        _pickedLocation =
            PlaceLocation(longitude: lng, latitude: lat, address: address);
        _isGettingLocation = false;
      });


    widget.onSelectLocation(_pickedLocation!);
  }

  Future<void> _openMap(String lat,String lng) async{
    if(_pickedLocation==null ){
      const snackBar1 = SnackBar(
          content: Text('No latitude longitude selected'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    };
    bool error1=false;
    String googleUrl='https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    await canLaunchUrlString(googleUrl) ? await launchUrlString(googleUrl)  : error1=false;

    if(error1=false){
      const snackBar = SnackBar(
        content: Text('Error on loading google map'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent=Text(
      "No location chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    final _pickedLocation = this._pickedLocation;
    if(_pickedLocation!=null){
      previewContent= Center(
        child: Text(_pickedLocation.address,style: TextStyle(color: Theme.of(context).colorScheme.onBackground),textAlign: TextAlign.center,)
      );

    }

    if(_isGettingLocation){
      previewContent=const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2))),
          child:previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed:(){ if (_pickedLocation != null)
              {
              _openMap(_pickedLocation.latitude.toString(),
              _pickedLocation.longitude.toString());
              }
              },
              icon: const Icon(Icons.map),
              label: const Text('See location on Map'),
            ),
          ],
        )
      ],
    );
  }
}
