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
  String? _lastRemovedId;

  void _removePlace(String id) async {
    final userPlacesNotifier = ref.read(userPlacesProvider.notifier);
    _lastRemovedPlace = ref.read(userPlacesProvider).firstWhere((place) => place.id == id);
    _lastRemovedId = id;
    await userPlacesNotifier.removePlace(id);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_lastRemovedPlace!.title} dismissed'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            await userPlacesNotifier.addPlace(
              _lastRemovedPlace!.title,
              _lastRemovedPlace!.memory,
              _lastRemovedPlace!.image,
              _lastRemovedPlace!.location,
              _lastRemovedPlace!.dateTime,
            );

            setState(() {});
          },
        ),
      ),
    );
  }

  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
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
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return PlacesList(
                places: userPlaces,
                onRemovePlace: _removePlace,
              );
            }
          },
        ),
      ),
    );
  }
}
