import 'dart:convert';
import 'package:flutter/services.dart';
import 'attraction.dart';

Map<String, String> studioAttractionPhotos = {
  "Avengers Assemble: Flight Force": "assets/AvengersAssemble.jpg",
  "Avengers Assemble: Flight Force Single Rider": "assets/AvengersAssemble.jpg",
  "Spider-Man W.E.B. Adventure": "assets/SpidermanWeb.jpg",
  "Spider-Man W.E.B. Adventure Single Rider": "assets/SpidermanWeb.jpg",
  "Meet Spider Man": "assets/MeetSpiderman.jpg",
  "The Twilight Zone Tower of Terror": "assets/TwilightZoneTowerofTerror.jpg",
  "Art of Disney Animation": "assets/ArtDisney.jpg",
  "Cars Quatre Roues Rallye": "assets/CarsQuatreRouesRallye.jpg",
  "Cars ROAD TRIP": "assets/CarsRoadTrip.jpg",
  "Crush's Coaster": "assets/CrushCoaster.jpg",
  "Crush's Coaster Single Rider": "assets/CrushCoaster.jpg",
  "Les Tapis Volants - Flying Carpets Over Agrabah®": "assets/TapisVolants.jpg",
  "Ratatouille: The Adventure": "assets/Ratatouille.jpg",
  "Ratatouille: The Adventure Single Rider": "assets/Ratatouille.jpg",
  "RC Racer": "assets/RCracer.jpg",
  "RC Racer Single Rider": "assets/RCracer.jpg",
  "Slinky® Dog Zigzag Spin": "assets/ZigZagSpin.jpg",
  "Toy Soldiers Parachute Drop": "assets/ToySoldiersParachuteDrop.jpg",
  "Toy Soldiers Parachute Drop Single Rider": "assets/ToySoldiersParachuteDrop.jpg",
  "Armageddon : les Effets Spéciaux": "assets/Dumbo.jpg",
  "Rock'n'Roller Coaster starring Aerosmith": "assets/Dumbo.jpg",
};

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

      String photoUrl = studioAttractionPhotos.containsKey(name) ? studioAttractionPhotos[name]! : "default.jpg";

      Attraction attraction = Attraction(
        name: name,
        isAvailable: isOpen,
        waitTime: waitTime,
        secteur: "", // Par défaut
        photoUrl: photoUrl,
      );

      attractionsList.add(attraction);
    }
  }

  return attractionsList;
}
