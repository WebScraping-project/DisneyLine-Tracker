import 'dart:async';

import 'package:flutter/material.dart';
import 'attraction.dart';
import 'liste_attractions.dart';
import 'liste_attraction_studio.dart'; // Importer le fichier pour les attractions des Disney Studios
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        cardColor: Colors.white,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Color getColorForWaitTime(int waitTime) {
  if (waitTime < 15) {
    return Colors.green;
  } else if (waitTime < 30) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Attraction> disneylandAttractions;
  late List<Attraction> studioAttractions;
  List<Attraction> filteredAttractions = [];
  List<Attraction> favoriteAttractions = [];
  String selectedView = 'Disneyland';

  @override
  void initState() {
    super.initState();
    _loadAttractions();
  }

  Future<void> _loadAttractions() async {
    disneylandAttractions = await parseAttractions();
    studioAttractions = await parseStudioAttractions();

    // Initialiser filteredAttractions avec les attractions de Disneyland par défaut
    filteredAttractions = List.from(disneylandAttractions);

    setState(() {});
  }

  void _onViewChanged(String? view) {
    setState(() {
      selectedView = view ?? 'Disneyland';

      if (view == 'Toutes les attractions') {
        filteredAttractions = List.from(disneylandAttractions);
      } else {
        filteredAttractions = disneylandAttractions
            .where((attraction) => attraction.secteur == view)
            .toList();
      }
    });
  }

  Widget buildAttractionsInfoContainer() {
    int totalAttractions =
        disneylandAttractions.length + studioAttractions.length;
    int availableAttractions = disneylandAttractions
            .where((attraction) => attraction.isAvailable)
            .length +
        studioAttractions.where((attraction) => attraction.isAvailable).length;

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          '$availableAttractions / $totalAttractions Attractions disponibles',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Colors.blue, Colors.green],
            ).createShader(bounds);
          },
          child: Center(
            child: Text(
              'Disneyline Tracker',
              style: GoogleFonts.dancingScript(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Couleur du texte
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white, // Ajout de la couleur de fond blanche
      body: Row(
        children: [
          // Partie gauche avec la liste des attractions Disneyland
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: disneylandAttractions == null
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Disneyland',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  initialValue: selectedView,
                                  onSelected: _onViewChanged,
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      'Toutes les attractions',
                                      'Main Street U.S.A',
                                      'Frontierland',
                                      'Adventureland',
                                      'Fantasyland',
                                      'Discoveryland',
                                    ].map((String view) {
                                      return PopupMenuItem<String>(
                                        value: view,
                                        child: Text(view),
                                      );
                                    }).toList();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Expanded(
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 600),
                                child: ListView.builder(
                                  itemCount: filteredAttractions.length,
                                  itemBuilder: (context, index) {
                                    var attraction = filteredAttractions[index];
                                    return Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        elevation: 5,
                                        color: Colors
                                            .white, // Couleur de fond blanche
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              attraction.photoUrl,
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: Text(
                                            attraction.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text.rich(
                                            TextSpan(
                                              text: 'Temps d\'attente: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${attraction.waitTime} minutes',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: getColorForWaitTime(
                                                        attraction.waitTime),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                attraction.isAvailable
                                                    ? Icons.check_circle
                                                    : Icons.cancel,
                                                color: attraction.isAvailable
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                              SizedBox(
                                                  width:
                                                      8), // Espacement entre les icônes
                                              IconButton(
                                                icon: Icon(
                                                  attraction.isFavorite
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    attraction.isFavorite =
                                                        !attraction.isFavorite;
                                                    if (attraction.isFavorite) {
                                                      favoriteAttractions
                                                          .add(attraction);
                                                    } else {
                                                      favoriteAttractions
                                                          .remove(attraction);
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          // Partie milieu avec la liste des attractions des Disney Studios
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: studioAttractions == null
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Disney Studios',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Expanded(
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 600),
                                child: ListView.builder(
                                  itemCount: studioAttractions.length,
                                  itemBuilder: (context, index) {
                                    var attraction = studioAttractions[index];
                                    return Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        elevation: 5,
                                        color: Colors
                                            .white, // Couleur de fond blanche
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              attraction.photoUrl,
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: Text(
                                            attraction.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text.rich(
                                            TextSpan(
                                              text: 'Temps d\'attente: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${attraction.waitTime} minutes',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: getColorForWaitTime(
                                                        attraction.waitTime),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                attraction.isAvailable
                                                    ? Icons.check_circle
                                                    : Icons.cancel,
                                                color: attraction.isAvailable
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                              SizedBox(
                                                  width:
                                                      8), // Espacement entre les icônes
                                              IconButton(
                                                icon: Icon(
                                                  attraction.isFavorite
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    attraction.isFavorite =
                                                        !attraction.isFavorite;
                                                    if (attraction.isFavorite) {
                                                      favoriteAttractions
                                                          .add(attraction);
                                                    } else {
                                                      favoriteAttractions
                                                          .remove(attraction);
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          // Partie droite avec les attractions favorites
          SizedBox(
            width: 400.0, // Ajustez la largeur selon vos besoins
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildAttractionsInfoContainer(),
                const SizedBox(height: 16.0),
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  constraints: const BoxConstraints(
                    maxHeight: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Attractions Favorites',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      for (var attraction in favoriteAttractions)
                        ListTile(
                          title: Text(attraction.name),
                          subtitle: Text.rich(
                            TextSpan(
                              text: 'Temps d\'attente: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: '${attraction.waitTime} minutes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: getColorForWaitTime(
                                        attraction.waitTime),
                                  ),
                                ),
                              ],
                            ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
