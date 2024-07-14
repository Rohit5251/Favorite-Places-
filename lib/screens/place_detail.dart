import 'package:favorite_places/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    Widget mem =Column(
      children: [
        Text("Memories : ${place.memory}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(height: 10,),
      ],
    );
    if(place.memory.isEmpty){
      mem=const SizedBox(height: 2,);
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    alignment:Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    ),
                    child: Column(
                      children: [
                        Text("Location Name : ${place.title}",
                        textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onBackground),
                        ),

                        mem,


                        Text(place.location.address,
                        textAlign: TextAlign.center,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onBackground,
                        ),
                                          ),
                        const SizedBox(height: 30,)
                      ],
                    )
                  )
                ],
              )
          )
        ],
      )
    );
  }
}
