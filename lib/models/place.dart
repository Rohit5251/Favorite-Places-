import 'package:uuid/uuid.dart';
import 'dart:io';
const  uuid=Uuid();

class PlaceLocation{
  const PlaceLocation({required this.longitude,required this.latitude,required this.address});
  final double latitude;
  final double longitude;
  final String address;
}


class Place{
  Place(
      {required this.title,
        required this.memory,
        required this.image,
        required this.location,
        required this.dateTime,
        String? id,
      }) : id =id ?? uuid.v4();

  final String id;
  final String title;
  final String memory;
  final File image;
  final PlaceLocation location;
  final String dateTime;
}
