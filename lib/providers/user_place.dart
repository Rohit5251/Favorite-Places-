import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'dart:io';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title, String memory, File image, PlaceLocation location, String dateTime, {int? index}) async {
    final appDir = await syspaths.getApplicationSupportDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace = Place(title: title, image: copiedImage, location: location, memory: memory, dateTime: dateTime);
    if (index != null) {
      final newState = List<Place>.from(state);
      newState.insert(index, newPlace);
      state = newState;
    } else {
      state = [newPlace, ...state];
    }
  }

  void removePlace(int index) {
    state = List.from(state)..removeAt(index);
  }
}

final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
);
