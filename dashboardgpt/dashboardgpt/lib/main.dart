import 'dart:async';
import 'package:flutter/material.dart';
import 'attraction.dart';
import 'liste_attractions.dart';
import 'liste_attraction_studio.dart'; // Importer le fichier pour les attractions des Disney Studios
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
  List<Attraction> filteredDisneylandAttractions = [];
  List<Attraction> filteredStudioAttractions = [];
  List<Attraction> favoriteAttractions = [];
  String selectedView = 'Disneyland';
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadAttractions();
  }

  Future<void> _loadAttractions() async {
    disneylandAttractions = await parseAttractions();
    studioAttractions = await parseStudioAttractions();
    filteredDisneylandAttractions = List.from(disneylandAttractions);
    filteredStudioAttractions = List.from(studioAttractions);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(1, 2, 57, 1.0),
                Color.fromRGBO(1, 2, 57, 1.0),
                Color.fromRGBO(0, 181, 190, 1),
                // Color.fromRGBO(246, 248, 240, 1.0),
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20.0), // Arrondir les bords
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/Titre.png', // Remplacez 'votre_logo.png' par le chemin de votre logo
                    width: 800, // Ajustez la largeur du logo selon vos besoins
                    height: 80, // Ajustez la hauteur du logo selon vos besoins
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              FilterWidget(
                selectedFilter: selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    if (selectedFilter == filter) {
                      selectedFilter = null;
                    } else {
                      selectedFilter = filter;
                    }
                    applyFilter();
                  });
                },
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        // ignore: unnecessary_null_comparison
                        child: disneylandAttractions == null
                            ? const CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 150.0, top: 40.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Disneyland',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            initialValue: selectedView,
                                            onSelected: _onViewChanged,
                                            itemBuilder:
                                                (BuildContext context) {
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
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors
                                                    .white, // Définit la couleur de l'icône en blanc
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
                                      SizedBox(
                                        height: 440.0,
                                        width: 800,
                                        child: ListView.builder(
                                          itemCount:
                                              filteredDisneylandAttractions
                                                  .length,
                                          itemBuilder: (context, index) {
                                            var attraction =
                                                filteredDisneylandAttractions[
                                                    index];
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 16.0),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                elevation: 5,
                                                color: Colors.white,
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0),
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Image.asset(
                                                      attraction.photoUrl,
                                                      width: 56,
                                                      height: 56,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    attraction.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Text.rich(
                                                    TextSpan(
                                                      text:
                                                          'Temps d\'attente: ',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              '${attraction.waitTime} minutes',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: getColorForWaitTime(
                                                                attraction
                                                                    .waitTime),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        attraction.isAvailable
                                                            ? Icons.check_circle
                                                            : Icons.cancel,
                                                        color: attraction
                                                                .isAvailable
                                                            ? Colors.green
                                                            : Colors.red,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      IconButton(
                                                        icon: Icon(
                                                          attraction.isFavorite
                                                              ? Icons.star
                                                              : Icons
                                                                  .star_border,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            attraction
                                                                    .isFavorite =
                                                                !attraction
                                                                    .isFavorite;
                                                            if (attraction
                                                                .isFavorite) {
                                                              favoriteAttractions
                                                                  .add(
                                                                      attraction);
                                                            } else {
                                                              favoriteAttractions
                                                                  .remove(
                                                                      attraction);
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
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        // ignore: unnecessary_null_comparison
                        child: studioAttractions == null
                            ? const CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 40.0, right: 80),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Disney Studios',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      SizedBox(
                                        height: 440.0,
                                        width: 800,
                                        child: ListView.builder(
                                          itemCount:
                                              filteredStudioAttractions.length,
                                          itemBuilder: (context, index) {
                                            var attraction =
                                                filteredStudioAttractions[
                                                    index];
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 16.0),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                elevation: 5,
                                                color: Colors.white,
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0),
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Image.asset(
                                                      attraction.photoUrl,
                                                      width: 56,
                                                      height: 56,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    attraction.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Text.rich(
                                                    TextSpan(
                                                      text:
                                                          'Temps d\'attente: ',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              '${attraction.waitTime} minutes',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: getColorForWaitTime(
                                                                attraction
                                                                    .waitTime),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        attraction.isAvailable
                                                            ? Icons.check_circle
                                                            : Icons.cancel,
                                                        color: attraction
                                                                .isAvailable
                                                            ? Colors.green
                                                            : Colors.red,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      IconButton(
                                                        icon: Icon(
                                                          attraction.isFavorite
                                                              ? Icons.star
                                                              : Icons
                                                                  .star_border,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            attraction
                                                                    .isFavorite =
                                                                !attraction
                                                                    .isFavorite;
                                                            if (attraction
                                                                .isFavorite) {
                                                              favoriteAttractions
                                                                  .add(
                                                                      attraction);
                                                            } else {
                                                              favoriteAttractions
                                                                  .remove(
                                                                      attraction);
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
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 100.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 300.0,
                          child: SizedBox(
                            height: 800.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                buildAttractionsInfoContainer(),
                                const SizedBox(height: 16.0),
                                Container(
                                  constraints:
                                      const BoxConstraints(maxHeight: 430),
                                  child: Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(16.0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black,
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            favoriteAttractions.isEmpty
                                                ? const Text(
                                                    'Aucune attraction favorite actuellement',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  )
                                                : Column(
                                                    children: [
                                                      for (var attraction
                                                          in favoriteAttractions)
                                                        ListTile(
                                                          title: Text(
                                                              attraction.name),
                                                          subtitle: Text.rich(
                                                            TextSpan(
                                                              text:
                                                                  'Temps d\'attente: ',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      '${attraction.waitTime} minutes',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: getColorForWaitTime(
                                                                        attraction
                                                                            .waitTime),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          trailing: Icon(
                                                            attraction
                                                                    .isAvailable
                                                                ? Icons
                                                                    .check_circle
                                                                : Icons.cancel,
                                                            color: attraction
                                                                    .isAvailable
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: StarBackground(),
        ),
      ]),
    );
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
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Text(
          'Attractions disponibles : $availableAttractions / $totalAttractions',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  void _onViewChanged(String? view) {
    setState(() {
      selectedView = view ?? 'Disneyland';
      applyFilter();
    });
  }

  void applyFilter() {
    switch (selectedFilter) {
      case 'waitTime':
        filteredDisneylandAttractions
            .sort((a, b) => a.waitTime.compareTo(b.waitTime));
        filteredStudioAttractions
            .sort((a, b) => a.waitTime.compareTo(b.waitTime));
        break;
      case 'favorites':
        filteredDisneylandAttractions = disneylandAttractions
            .where((attraction) => attraction.isFavorite)
            .toList();
        filteredStudioAttractions = studioAttractions
            .where((attraction) => attraction.isFavorite)
            .toList();
        break;
      case 'availability': // Ajout du cas pour le tri par disponibilité
        filteredDisneylandAttractions.sort((a, b) => a.isAvailable
            ? -1
            : 1); // Trier Disneyland en fonction de la disponibilité
        filteredStudioAttractions.sort((a, b) => a.isAvailable
            ? -1
            : 1); // Trier Studio en fonction de la disponibilité
        break;

      default:
        filteredDisneylandAttractions = disneylandAttractions;
        filteredStudioAttractions = studioAttractions;
    }
  }
}

class StarBackground extends StatelessWidget {
  const StarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: StarPainter(),
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  List<Star> stars;

  StarPainter() : stars = generateStars();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var star in stars) {
      canvas.drawCircle(Offset(star.x, star.y), star.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

List<Star> generateStars() {
  final random = Random();
  List<Star> stars = [];
  for (int i = 0; i < 100; i++) {
    final x = random.nextDouble() * 2000;
    final y = random.nextDouble() *
        1000; // ajustez la taille de l'écran selon vos besoins
    final radius = random.nextDouble() * 1.5; // Taille des étoiles aléatoire
    stars.add(Star(x: x, y: y, radius: radius));
  }
  return stars;
}

class Star {
  final double x;
  final double y;
  final double radius;

  Star({required this.x, required this.y, required this.radius});
}

class FilterWidget extends StatelessWidget {
  final String? selectedFilter;
  final Function(String)? onFilterChanged;

  const FilterWidget({super.key, this.selectedFilter, this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 120.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 175.0),
            child: Text(
              'Trier par :',
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                if (onFilterChanged != null) {
                  onFilterChanged!('waitTime');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedFilter == 'waitTime'
                    ? Colors.green
                    : Colors
                        .white, // Change background color based on selection
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Temps d\'attente',
                style: TextStyle(
                  color: selectedFilter == 'waitTime'
                      ? Colors.white
                      : Colors.black, // Change text color based on selection
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                if (onFilterChanged != null) {
                  onFilterChanged!('favorites');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedFilter == 'favorites'
                    ? Colors.green
                    : Colors
                        .white, // Change background color based on selection
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Favoris',
                style: TextStyle(
                  color: selectedFilter == 'favorites'
                      ? Colors.white
                      : Colors.black, // Change text color based on selection
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                if (onFilterChanged != null) {
                  onFilterChanged!('availability');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedFilter == 'availability'
                    ? Colors.green
                    : Colors
                        .white, // Change background color based on selection
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Disponibilité',
                style: TextStyle(
                  color: selectedFilter == 'availability'
                      ? Colors.white
                      : Colors.black, // Change text color based on selection
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
