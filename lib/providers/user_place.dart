import 'dart:io';
import 'package:favorite_places/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbpath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,memory TEXT, image TEXT, dateTime TEXT,lat REAL, lng REAL, address TEXT)',
      );
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map((row) =>
        Place(
          id: row['id'] as String,
          title: row['title'] as String,
          memory: row['memory'] as String,
          image: File(row['image'] as String),
          location: PlaceLocation(
            latitude: row['lat'] as double,
            longitude: row['lng'] as double,
            address: row['address'] as String,
          ),
          dateTime: row['dateTime'] as String,
        )).toList();

    state = places;
  }

  Future<void> update(String title, String memory, File image, PlaceLocation location,
      String dateTime,) async {
    final appDir = await syspaths.getApplicationSupportDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace = Place(
      // Unique ID
      title: title,
      image: copiedImage,
      location: location,
      memory: memory,
      dateTime: dateTime,
    );
    final db = await _getDatabase();
    await db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'memory': newPlace.memory,
      'image': newPlace.image.path,
      'dateTime': newPlace.dateTime,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    //state = [newPlace, ...state];
  }


  Future<void> addPlace(String title, String memory, File image, PlaceLocation location,
      String dateTime,) async {
    final appDir = await syspaths.getApplicationSupportDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace = Place(
      // Unique ID
      title: title,
      image: copiedImage,
      location: location,
      memory: memory,
      dateTime: dateTime,
    );
    final db = await _getDatabase();
    await db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'memory': newPlace.memory,
      'image': newPlace.image.path,
      'dateTime': newPlace.dateTime,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }

  Future<int> removePlace(String id) async {
    final db = await _getDatabase();
    var result = await db.delete(
        'user_places', where: 'id = ?', whereArgs: [id]);
    state = List.from(state)
      ..remove(id); // Removing the place from the state
    return result;
  }


}
final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
);