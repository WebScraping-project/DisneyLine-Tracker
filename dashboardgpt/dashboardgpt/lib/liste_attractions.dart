import 'dart:convert';
import 'package:flutter/services.dart';
import 'attraction.dart';

Future<String> _loadJsonData() async {
  return await rootBundle.loadString('assets/donnees_api.json');
}

Future<List<Attraction>> parseAttractions() async {
  String jsonData = await _loadJsonData();

  List<Attraction> attractionsList = [];

  Map<String, dynamic> jsonDataMap = jsonDecode(jsonData);

  List<dynamic> lands = jsonDataMap['lands'];

  for (var land in lands) {
    String secteur = land['name'];
    List<dynamic> rides = land['rides'];

    for (var ride in rides) {
      String name = ride['name'];
      bool isOpen = ride['is_open'];
      int waitTime = ride['wait_time'];
      String photoUrl = ''; // Définir l'URL de la photo par défaut

      // Ajouter des conditions pour définir la photoUrl en fonction du nom ou de l'ID de l'attraction

      Attraction attraction = Attraction(
        name: name,
        isAvailable: isOpen,
        waitTime: waitTime,
        secteur: secteur,
        photoUrl: photoUrl,
      );

      attractionsList.add(attraction);
    }
  }

  return attractionsList;
}
