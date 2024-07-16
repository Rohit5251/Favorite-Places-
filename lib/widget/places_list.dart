import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_detail.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key, required this.places, required this.onRemovePlace});

  final List<Place> places;
  final Function(String id) onRemovePlace;

  @override
  _PlacesListState createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  late List<Place> _places;
  Place? _recentlyRemovedPlace;
  int? _recentlyRemovedPlaceIndex;

  @override
  void initState() {
    super.initState();
    _places = widget.places;
  }

  @override
  void didUpdateWidget(covariant PlacesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.places != widget.places) {
      setState(() {
        _places = widget.places;
      });
    }
  }

  void _removePlace(int index) {
    setState(() {
      _recentlyRemovedPlace = _places[index];
      _recentlyRemovedPlaceIndex = index;
      _places.removeAt(index);
    });

    widget.onRemovePlace(_recentlyRemovedPlace!.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Place removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _places.insert(_recentlyRemovedPlaceIndex!, _recentlyRemovedPlace!);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_places.isEmpty) {
      return Center(
        child: Text(
          "No places added yet",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _places.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(_places[index].id),
        background: Container(
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          _removePlace(index);
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(_places[index].image),
          ),
          title: Text(
            _places[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          subtitle: Text(
            _places[index].location.address,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlaceDetailScreen(place: _places[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
