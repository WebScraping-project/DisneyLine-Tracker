import 'dart:convert';
import 'package:flutter/services.dart';
import 'attraction.dart';

Map<String, String> attractionPhotos = {
  "Adventure Isle": "assets/AdventureIsle.jpg",
  "Indiana Jones and the Temple of Peril Single Rider":
      "assets/IndianaJones.jpg",
  "Indiana Jones™ and the Temple of Peril": "assets/IndianaJones.jpg",
  "La Cabane des Robinson": "assets/CabaneRobinson.jpg",
  "Le Passage Enchanté d'Aladdin": "assets/PassageAladin.jpg",
  "Pirate Galleon": "assets/PirateGalleon.jpg",
  "Pirates of the Caribbean": "assets/PirateCaribbean.jpg",
  "Pirates' Beach": "assets/PiratesBeach.jpg",
  "Autopia, presented by Avis": "assets/Autopia.jpg",
  "Buzz Lightyear Laser Blast": "assets/BuzzLightyear.jpg",
  "Disneyland Railroad Discoveryland Station": "assets/DisneyRailroad.jpg",
  "Les Mystères du Nautilus": "assets/Nautilus.jpg",
  "Mickey’s PhilharMagic": "assets/MickeyPhilharMagic.jpg",
  "Orbitron®": "assets/Orbitron.jpg",
  "Star Tours: The Adventures Continue*": "assets/StarTours.jpg",
  "Star Wars Hyperspace Mountain": "assets/HyperspaceMountain.jpg",
  "Star Wars Hyperspace Mountain Single Rider": "assets/HyperspaceMountain.jpg",
  "Welcome to Starport: A Star Wars Encounter": "assets/Starport.jpg",
  "\"it's a small world\"": "assets/ItsaSmallWorld.jpg",
  "Alice's Curious Labyrinth": "assets/AliceLabyrinth.jpg",
  "Blanche-Neige et les Sept Nains®": "assets/BlancheNeige.jpg",
  "Casey Jr. – le Petit Train du Cirque": "assets/CaseyJr.jpg",
  "Disneyland Railroad": "assets/DisneyRailroad.jpg",
  "Disneyland Railroad Fantasyland Station": "assets/DisneyRailroad.jpg",
  "Dumbo the Flying Elephant": "assets/Dumbo.jpg",
  "La Tanière du Dragon": "assets/TaniereDragon.jpg",
  "Le Carrousel de Lancelot ": "assets/CarrouselLancelot.jpg",
  "Le Pays des Contes de Fées": "assets/PaysContesFees.jpg",
  "Les Voyages de Pinocchio": "assets/Pinocchio.jpg",
  "Mad Hatter's Tea Cups": "assets/TeaCups.jpg",
  "Meet Mickey Mouse": "assets/RencontreMickey.jpg",
  "Peter Pan's Flight": "assets/PeterPan.jpg",
  "Princess Pavilion": "assets/PavillonPrincesses.jpg",
  "Big Thunder Mountain": "assets/BigThunderMountain.jpg",
  "Disneyland Railroad Frontierland Depot": "assets/DisneyRailroad.jpg",
  "Frontierland Playground": "assets/FrontierlandPlayground.jpg",
  "Phantom Manor": "assets/PhantomManor.jpg",
  "River Rogue Keelboats": "assets/RiverRogue.jpg",
  "Rustler Roundup Shootin' Gallery": "assets/RustlerRoundup.jpg",
  "Thunder Mesa Riverboat Landing": "assets/RiverRogue.jpg",
  "Disneyland Railroad Main Street Station": "assets/DisneyRailroad.jpg",
  "Main Street Vehicles": "assets/MainStreetVehicles.jpg",
};

Future<String> _loadJsonData() async {
  return await rootBundle.loadString('assets/disneyland.json');
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

      String photoUrl = attractionPhotos.containsKey(name)
          ? attractionPhotos[name]!
          : "default.jpg";

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
