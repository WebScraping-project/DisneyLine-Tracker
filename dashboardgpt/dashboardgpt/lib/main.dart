import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Attraction {
  final String name;
  final String photoUrl;
  final int waitTime;
  final bool isAvailable;

  Attraction({
    required this.name,
    required this.photoUrl,
    required this.waitTime,
    required this.isAvailable,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Attraction> attractions = [
    Attraction(
        name: 'Space Mountain',
        photoUrl: 'assets/space_mountain.jpg',
        waitTime: 30,
        isAvailable: true),
    Attraction(
        name: 'Splash Mountain',
        photoUrl: 'assets/splash_mountain.jpg',
        waitTime: 45,
        isAvailable: false),
    Attraction(
        name: 'Big Thunder Mountain',
        photoUrl: 'assets/big_thunder_mountain.jpg',
        waitTime: 20,
        isAvailable: true),
    Attraction(
        name: 'Haunted Mansion',
        photoUrl: 'assets/haunted_mansion.jpg',
        waitTime: 15,
        isAvailable: true),
    Attraction(
        name: 'Pirates of the Caribbean',
        photoUrl: 'assets/pirates.jpg',
        waitTime: 40,
        isAvailable: true),
    Attraction(
        name: 'It\'s a Small World',
        photoUrl: 'assets/small_world.jpg',
        waitTime: 10,
        isAvailable: false),
    Attraction(
        name: 'Rock \'n\' Roller Coaster',
        photoUrl: 'assets/rock_n_roller_coaster.jpg',
        waitTime: 25,
        isAvailable: true),
    Attraction(
        name: 'Test Track',
        photoUrl: 'assets/test_track.jpg',
        waitTime: 35,
        isAvailable: false),
    Attraction(
        name: 'Expedition Everest',
        photoUrl: 'assets/expedition_everest.jpg',
        waitTime: 50,
        isAvailable: true),
    Attraction(
        name: 'Buzz Lightyear Astro Blasters',
        photoUrl: 'assets/buzz_lightyear.jpg',
        waitTime: 18,
        isAvailable: true),
    Attraction(
        name: 'Dumbo the Flying Elephant',
        photoUrl: 'assets/dumbo.jpg',
        waitTime: 12,
        isAvailable: true),
    Attraction(
        name: 'Matterhorn Bobsleds',
        photoUrl: 'assets/matterhorn.jpg',
        waitTime: 28,
        isAvailable: false),
    Attraction(
        name: 'Tower of Terror',
        photoUrl: 'assets/tower_of_terror.jpg',
        waitTime: 22,
        isAvailable: true),
    Attraction(
        name: 'Indiana Jones Adventure',
        photoUrl: 'assets/indiana_jones.jpg',
        waitTime: 38,
        isAvailable: true),
    Attraction(
        name: 'Seven Dwarfs Mine Train',
        photoUrl: 'assets/seven_dwarfs.jpg',
        waitTime: 32,
        isAvailable: true),
    Attraction(
        name: 'The Twilight Zone Tower of Terror',
        photoUrl: 'assets/twilight_zone_tower.jpg',
        waitTime: 40,
        isAvailable: false),
    Attraction(
        name: 'The Little Mermaid: Ariel\'s Undersea Adventure',
        photoUrl: 'assets/little_mermaid.jpg',
        waitTime: 15,
        isAvailable: true),
    Attraction(
        name: 'Soarin\' Around the World',
        photoUrl: 'assets/soarin.jpg',
        waitTime: 30,
        isAvailable: true),
    Attraction(
        name: 'Space Mountain: Mission 2',
        photoUrl: 'assets/space_mountain_mission_2.jpg',
        waitTime: 55,
        isAvailable: true),
    Attraction(
        name: 'Slinky Dog Dash',
        photoUrl: 'assets/slinky_dog_dash.jpg',
        waitTime: 25,
        isAvailable: true),
    Attraction(
        name: 'Ratatouille: The Adventure',
        photoUrl: 'assets/ratatouille.jpg',
        waitTime: 18,
        isAvailable: false),
    Attraction(
        name: 'Big Hero 6: The Ride',
        photoUrl: 'assets/big_hero_6.jpg',
        waitTime: 20,
        isAvailable: true),
    Attraction(
        name: 'Frozen Ever After',
        photoUrl: 'assets/frozen_ever_after.jpg',
        waitTime: 30,
        isAvailable: true),
    Attraction(
        name: 'Guardians of the Galaxy: Mission Breakout!',
        photoUrl: 'assets/guardians_of_the_galaxy.jpg',
        waitTime: 42,
        isAvailable: true),
    Attraction(
        name: 'Millennium Falcon: Smugglers Run',
        photoUrl: 'assets/millennium_falcon.jpg',
        waitTime: 48,
        isAvailable: false),
    Attraction(
        name: 'Peter Pan\'s Flight',
        photoUrl: 'assets/peter_pan.jpg',
        waitTime: 15,
        isAvailable: true),
    Attraction(
        name: 'Star Tours – The Adventures Continue',
        photoUrl: 'assets/star_tours.jpg',
        waitTime: 28,
        isAvailable: true),
    Attraction(
        name: 'The Great Movie Ride',
        photoUrl: 'assets/great_movie_ride.jpg',
        waitTime: 18,
        isAvailable: true),
    Attraction(
        name: 'Walt Disney\'s Enchanted Tiki Room',
        photoUrl: 'assets/enchanted_tiki_room.jpg',
        waitTime: 10,
        isAvailable: true),
    Attraction(
        name: 'Toy Story Midway Mania!',
        photoUrl: 'assets/toy_story_mania.jpg',
        waitTime: 25,
        isAvailable: true),
    // Ajoutez d'autres attractions ici
  ];

  List<Attraction> filteredAttractions = [];

  String selectedView = 'Toutes les attractions';

  @override
  void initState() {
    super.initState();
    filteredAttractions = List.from(attractions);
  }

  void _onViewChanged(String? view) {
    setState(() {
      selectedView = view ?? 'Toutes les attractions';
      if (view == 'Toutes les attractions') {
        filteredAttractions = List.from(attractions);
      } else {
        filteredAttractions = attractions
            .where((attraction) => attraction.name.startsWith(view!))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disneyline Tracker'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(200.0),
          child: Column(
            children: [
              DropdownButton<String>(
                value: selectedView,
                onChanged: _onViewChanged,
                items: [
                  'Toutes les attractions',
                  'Space',
                  'Splash',
                  'Big Thunder',
                  'Haunted Mansion',
                  'Pirates',
                  'It\'s a Small World',
                  'Rock \'n\' Roller Coaster',
                  'Test Track',
                  'Expedition Everest',
                  'Buzz Lightyear Astro Blasters',
                  'Dumbo the Flying Elephant',
                  'Matterhorn Bobsleds',
                  'Tower of Terror',
                  'Indiana Jones Adventure',
                  'Seven Dwarfs Mine Train',
                  'The Twilight Zone Tower of Terror',
                  'The Little Mermaid: Ariel\'s Undersea Adventure',
                  'Soarin\' Around the World',
                  'Space Mountain: Mission 2',
                  'Slinky Dog Dash',
                  'Ratatouille: The Adventure',
                  'Big Hero 6: The Ride',
                  'Frozen Ever After',
                  'Guardians of the Galaxy: Mission Breakout!',
                  'Millennium Falcon: Smugglers Run',
                  'Peter Pan\'s Flight',
                  'Star Tours – The Adventures Continue',
                  'The Great Movie Ride',
                  'Walt Disney\'s Enchanted Tiki Room',
                  'Toy Story Midway Mania!'
                ].map((String view) {
                  return DropdownMenuItem<String>(
                    value: view,
                    child: Text(view),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredAttractions.length,
                  itemBuilder: (context, index) {
                    var attraction = filteredAttractions[index];
                    return ListTile(
                      leading: Image.asset(
                        attraction.photoUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                      title: Text(attraction.name),
                      subtitle: Text(
                          'Temps d\'attente: ${attraction.waitTime} minutes'),
                      trailing: Icon(
                        attraction.isAvailable
                            ? Icons.check_circle
                            : Icons.cancel,
                        color:
                            attraction.isAvailable ? Colors.green : Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
