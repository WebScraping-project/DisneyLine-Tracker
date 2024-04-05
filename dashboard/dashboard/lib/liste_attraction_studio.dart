import 'attraction.dart';
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';

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

List<Map<String, AttributeValue>> generateLandKeysStudio() {
  List<Map<String, AttributeValue>> landKeys = [];
  for (int i in [26,27,906]) {
    landKeys.add({'land_id': AttributeValue.fromJson({'S': '$i'})});
  }
  return landKeys;
}

List<Attraction> parseAttractionsStudioFromDynamo(Map<String, AttributeValue> data) {
  //String landId = data['land_id']!.s!;
  String landName = data['name']!.s!;
  List<dynamic>? ridesData = data['rides']!.l;

  List<Attraction> attractionsList = [];

  if (ridesData != null) {
    for (var rideData in ridesData) {
      Map<String, AttributeValue>? rideAttributes = rideData!.m;
      if (rideAttributes != null) {
        String name = rideAttributes['name']!.s!;
        bool isOpen = rideAttributes['is_open']!.boolValue!;
        int waitTime = int.parse(rideAttributes['wait_time']!.n!);

  
        String photoUrl = studioAttractionPhotos.containsKey(name)
          ? studioAttractionPhotos[name]!
          : "default.jpg";
    

        Attraction attraction = Attraction(
          name: name,
          isAvailable: isOpen,
          waitTime: waitTime,
          secteur: landName,
          photoUrl: photoUrl, 
        );

        attractionsList.add(attraction);
      }
    }
  }

  return attractionsList;
}

Future<List<Attraction>> attractionsStudio(DynamoDB dynamoDB, String tableName) async {
  List<Attraction> attractionsList = [];
  List<Map<String, AttributeValue>> keys= generateLandKeysStudio();

  for (Map<String, AttributeValue> key in keys) {
    final data= await dynamoDB.getItem(
      key: key,
      tableName: tableName,
    );
    attractionsList.addAll(parseAttractionsStudioFromDynamo(data.item!));
  }
  return attractionsList;
}
