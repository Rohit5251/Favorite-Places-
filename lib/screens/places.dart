import 'package:favorite_places/providers/user_place.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widget/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/place.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  Place? _lastRemovedPlace;
  int? _lastRemovedIndex;

  void _removePlace(int index) {
    final userPlacesNotifier = ref.read(userPlacesProvider.notifier);
    _lastRemovedPlace = ref.read(userPlacesProvider)[index];
    _lastRemovedIndex = index;
    userPlacesNotifier.removePlace(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_lastRemovedPlace!.title} dismissed'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            userPlacesNotifier.addPlace(
              _lastRemovedPlace!.title,
              _lastRemovedPlace!.memory,
              _lastRemovedPlace!.image,
              _lastRemovedPlace!.location,
              _lastRemovedPlace!.dateTime,
              index: _lastRemovedIndex,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Places"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlacesList(
          places: userPlaces,
          onRemovePlace: _removePlace,
        ),
      ),
    );
  }
}
