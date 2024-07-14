import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class UserPlacesNotifier extends StateNotifier<List<Place>>{
  UserPlacesNotifier() : super(const []);

  void addPlace(String title,String memory,File image,PlaceLocation location){
    final newPlace=Place(title: title,image: image,location: location, memory: memory);
    state =[newPlace,...state];
  }
}


final userPlacesProvider=StateNotifierProvider<UserPlacesNotifier,List<Place>>(
        (ref) => UserPlacesNotifier()
);
