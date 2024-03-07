// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Attraction> attractions = [
    Attraction(
        name: 'Space Mountain',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 30,
        isAvailable: true),
    Attraction(
        name: 'Splash Mountain',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 45,
        isAvailable: false),
    Attraction(
        name: 'Big Thunder Mountain',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 20,
        isAvailable: true),
    Attraction(
        name: 'Haunted Mansion',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 15,
        isAvailable: true),
    Attraction(
        name: 'Pirates of the Caribbean',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 40,
        isAvailable: true),
    Attraction(
        name: 'It\'s a Small World',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 10,
        isAvailable: false),
    Attraction(
        name: 'Rock \'n\' Roller Coaster',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 25,
        isAvailable: true),
    Attraction(
        name: 'Test Track',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 35,
        isAvailable: false),
    Attraction(
        name: 'Expedition Everest',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 50,
        isAvailable: true),
    Attraction(
        name: 'Buzz Lightyear Astro Blasters',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 18,
        isAvailable: true),
    Attraction(
        name: 'Dumbo the Flying Elephant',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 12,
        isAvailable: true),
    Attraction(
        name: 'Matterhorn Bobsleds',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 28,
        isAvailable: false),
    Attraction(
        name: 'Tower of Terror',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 22,
        isAvailable: true),
    Attraction(
        name: 'Indiana Jones Adventure',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 38,
        isAvailable: true),
    Attraction(
        name: 'Seven Dwarfs Mine Train',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 32,
        isAvailable: true),
    Attraction(
        name: 'The Twilight Zone Tower of Terror',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 40,
        isAvailable: false),
    Attraction(
        name: 'The Little Mermaid: Ariel\'s Undersea Adventure',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 15,
        isAvailable: true),
    Attraction(
        name: 'Soarin\' Around the World',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 30,
        isAvailable: true),
    Attraction(
        name: 'Space Mountain: Mission 2',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 55,
        isAvailable: true),
    Attraction(
        name: 'Slinky Dog Dash',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 25,
        isAvailable: true),
    Attraction(
        name: 'Ratatouille: The Adventure',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 18,
        isAvailable: false),
    Attraction(
        name: 'Big Hero 6: The Ride',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 20,
        isAvailable: true),
    Attraction(
        name: 'Frozen Ever After',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 30,
        isAvailable: true),
    Attraction(
        name: 'Guardians of the Galaxy: Mission Breakout!',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 42,
        isAvailable: true),
    Attraction(
        name: 'Millennium Falcon: Smugglers Run',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 48,
        isAvailable: false),
    Attraction(
        name: 'Peter Pan\'s Flight',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 15,
        isAvailable: true),
    Attraction(
        name: 'Star Tours – The Adventures Continue',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 28,
        isAvailable: true),
    Attraction(
        name: 'The Great Movie Ride',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 18,
        isAvailable: true),
    Attraction(
        name: 'Walt Disney\'s Enchanted Tiki Room',
        photoUrl: 'assets/Dumbo.jpg',
        waitTime: 10,
        isAvailable: true),
    Attraction(
        name: 'Toy Story Midway Mania!',
        photoUrl: 'assets/Dumbo.jpg',
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
        title: const Text('Disneyline Tracker'),
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 50.0, // Taille du texte
          fontWeight: FontWeight.bold, // Gras
          color: Colors.blue, // Couleur du texte
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(200.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.green],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: DropdownButton<String>(
                  value: selectedView,
                  onChanged: _onViewChanged,
                  items: [
                    'Toutes les attractions',
                    'Space',
                    'Splash',
                    'Big Thunder',
                    // ... (ajoutez le reste des éléments ici)
                    'Toy Story Midway Mania!',
                  ].map((String view) {
                    return DropdownMenuItem<String>(
                      value: view,
                      child: Text(
                        view,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredAttractions.length,
                  itemBuilder: (context, index) {
                    var attraction = filteredAttractions[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 158, 158, 158)
                                .withOpacity(0.2),
                            spreadRadius: 0.1,
                            blurRadius: 0,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            attraction.photoUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(attraction.name),
                        subtitle: Text(
                          'Temps d\'attente: ${attraction.waitTime} minutes',
                        ),
                        trailing: Icon(
                          attraction.isAvailable
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: attraction.isAvailable
                              ? Colors.green
                              : Colors.red,
                        ),
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
