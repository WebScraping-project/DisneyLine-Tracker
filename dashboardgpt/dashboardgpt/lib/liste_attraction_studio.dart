import 'dart:convert';
import 'package:flutter/services.dart';
import 'attraction.dart';

Future<String> _loadJsonData() async {
  return await rootBundle.loadString('assets/disney_studios.json');
}

Future<List<Attraction>> parseStudioAttractions() async {
  String jsonData = await _loadJsonData();

  List<Attraction> attractionsList = [];

  Map<String, dynamic> jsonDataMap = jsonDecode(jsonData);

  List<dynamic> lands = jsonDataMap['lands'];

  for (var land in lands) {
    List<dynamic> rides = land['rides'];

    for (var ride in rides) {
      String name = ride['name'];
      bool isOpen = ride['is_open'];
      int waitTime = ride['wait_time'];

      Attraction attraction = Attraction(
        name: name,
        isAvailable: isOpen,
        waitTime: waitTime,
        photoUrl: "default.jpg",
        secteur: "", // Par défaut
      );

      attractionsList.add(attraction);
    }
  }

  return attractionsList;
}
