

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_place.dart';
import 'package:favorite_places/widget/image_input.dart';
import 'package:favorite_places/widget/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  final _memoryController =TextEditingController();
  File? _selectedImage;
  String? _selectedDate;
  PlaceLocation? _selectedLocation;

  void _selectImage(File pickedImage) {
    _selectedImage = pickedImage;
  }
  void _dateSelect(String dateTime ){
    _selectedDate=dateTime;
  }


  void _savePlace() {
    final enteredText = _titleController.text;
    final enteredMemory =_memoryController.text;

    if (enteredText.isEmpty || _selectedImage == null || _selectedLocation==null) {
      const snackBarx = SnackBar(
        content: Text('Enter all data'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBarx);
    }

    ref.read(userPlacesProvider.notifier).addPlace(enteredText, enteredMemory ,_selectedImage!,_selectedLocation!,_selectedDate!);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Place"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Name of Location"),
              controller: _titleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(labelText: "Any Memory related to this place"),
              controller: _memoryController,
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 40),
            // Image input
            ImageInput(
              onPickedImage: _selectImage,
              onSelectDate: _dateSelect,
            ),
            const SizedBox(height: 10,),
            LocationInput(
              onSelectLocation: (location){
                _selectedLocation=location;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _savePlace,
              label: const Text('Add Place'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
