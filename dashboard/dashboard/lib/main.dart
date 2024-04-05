import 'package:flutter/material.dart';
import 'attraction.dart';
import 'liste_attractions.dart';
import 'liste_attraction_studio.dart';
import 'etoiles.dart';
import 'acces.dart';
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';

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
  List<Attraction> disneylandAttractions = [];
  List<Attraction> studioAttractions = [];
  List<Attraction> filteredDisneylandAttractions = [];
  List<Attraction> filteredStudioAttractions = [];
  List<Attraction> favoriteAttractions = [];
  String selectedView = 'Disneyland';
  List<String> selectedFilters = [];

  @override
  void initState() {
    super.initState();
    _loadAttractions();
  }

  Future<void> _loadAttractions() async {
    final dynamoDB = DynamoDB(
        region: 'eu-north-1',
        credentials: AwsClientCredentials(
          accessKey: ACCES_KEY,
          secretKey: SECRET_KEY,
        ));
    disneylandAttractions =
        await attractionsAllLands(dynamoDB, 'BDDdisneyland');
    studioAttractions = await attractionsStudio(dynamoDB, 'BDDdisneyland');
    filteredDisneylandAttractions = List.from(disneylandAttractions);
    filteredStudioAttractions = List.from(studioAttractions);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(1, 2, 57, 1.0),
                Color.fromRGBO(0, 195, 206, 1),
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20.0), // Arrondir les bords
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/Titre.png',
                    width:
                        screenSize.width * 0.42, // Ajustez la largeur du logo
                    height:
                        screenSize.height * 0.08, // Ajustez la hauteur du logo
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              FilterWidget(
                selectedFilters: selectedFilters,
                onFiltersChanged: (updatedFilters) {
                  setState(() {
                    selectedFilters =
                        updatedFilters; // Mettre à jour la liste de filtres lorsqu'ils changent

                    print(selectedFilters);
                    applyFilters(selectedFilters);
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
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.057,
                                    top: MediaQuery.of(context).size.height *
                                        0.04),
                                child: Container(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.height *
                                          0.016),
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
                                              fontSize: 25.0,
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
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.004),
                                              child: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors
                                                    .white, // Définit la couleur de l'icône en blanc
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      SizedBox(
                                        height: screenSize.height * 0.535,
                                        width: screenSize.width * 0.42,
                                        child: ListView.builder(
                                          itemCount:
                                              filteredDisneylandAttractions
                                                  .length,
                                          itemBuilder: (context, index) {
                                            var attraction =
                                                filteredDisneylandAttractions[
                                                    index];
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.016),
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
                                                      EdgeInsets.symmetric(
                                                          horizontal:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.008),
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Image.asset(
                                                      attraction.photoUrl,
                                                      width: screenSize.width *
                                                          0.03,
                                                      height:
                                                          screenSize.height *
                                                              0.057,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    attraction.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
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
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.004,
                                                      ),
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
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.height *
                                        0.01,
                                    top: MediaQuery.of(context).size.height *
                                        0.04,
                                    right: MediaQuery.of(context).size.width *
                                        0.042),
                                child: Container(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.height *
                                          0.016),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Disney Studios',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 25.0,
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            initialValue: selectedView,
                                            onSelected: _onViewChanged,
                                            itemBuilder:
                                                (BuildContext context) {
                                              return [
                                                'Toutes les attractions',
                                                'Marvel Avengers Campus',
                                                'Production Courtyard',
                                                'Toon Studio',
                                              ].map((String view) {
                                                return PopupMenuItem<String>(
                                                  value: view,
                                                  child: Text(view),
                                                );
                                              }).toList();
                                            },
                                            offset: const Offset(200, 0),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.004),
                                              child: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors
                                                    .white, // Définit la couleur de l'icône en blanc
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      SizedBox(
                                        height: screenSize.height * 0.535,
                                        width: screenSize.width * 0.417,
                                        child: ListView.builder(
                                          itemCount:
                                              filteredStudioAttractions.length,
                                          itemBuilder: (context, index) {
                                            var attraction =
                                                filteredStudioAttractions[
                                                    index];
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.016),
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
                                                      EdgeInsets.symmetric(
                                                          horizontal:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.0083),
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Image.asset(
                                                      attraction.photoUrl,
                                                      width: screenSize.width *
                                                          0.029,
                                                      height:
                                                          screenSize.height *
                                                              0.057,
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
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.004,
                                                      ),
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
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.052),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: screenSize.width * 0.208,
                          child: SizedBox(
                            height: screenSize.height * 0.807,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.026),
                                  child: buildAttractionsInfoContainer(),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.464),
                                  child: Expanded(
                                    child: Container(
                                      margin: EdgeInsets.all(
                                          MediaQuery.of(context).size.height *
                                              0.016),
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.height *
                                              0.016),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 0, 0, 0)
                                                .withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: const Offset(2, 3),
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
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01, // 1% de la hauteur de l'écran
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.208,
                                            ),
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
        const Positioned.fill(
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
        margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.016),
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.016),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
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
      selectedView = view ?? 'Disneyland'; // Mise à jour de la vue sélectionnée
      if (view != null && !selectedFilters.contains(view)) {
        selectedFilters
            .add(view); // Ajout de l'élément sélectionné à la liste des filtres
      }

      applyFilters(selectedFilters); // Application des filtres sélectionnés
    });
  }

  void applyFilters(List<String> selectedFilters) {
    filteredDisneylandAttractions = List.from(disneylandAttractions);
    filteredStudioAttractions = List.from(studioAttractions);

    if (selectedFilters.isEmpty) {
      // Aucun filtre sélectionné, ne rien faire ou afficher tout
      return;
    }

    // Appliquer chaque filtre sélectionné
    for (String filter in selectedFilters) {
      switch (filter) {
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

        case 'availability':
          filteredDisneylandAttractions = filteredDisneylandAttractions
              .where((attraction) => attraction.isAvailable)
              .toList();
          filteredStudioAttractions = filteredStudioAttractions
              .where((attraction) => attraction.isAvailable)
              .toList();
          break;
        case 'non_availability':
          filteredDisneylandAttractions = filteredDisneylandAttractions
              .where((attraction) => !attraction.isAvailable)
              .toList();
          filteredStudioAttractions = filteredStudioAttractions
              .where((attraction) => !attraction.isAvailable)
              .toList();
          break;

// filtrage des lands du parc disneyland
        case 'Main Street U.S.A':
          filteredDisneylandAttractions = filteredDisneylandAttractions
              .where((attraction) => attraction.secteur == 'Main Street U.S.A')
              .toList();
          selectedFilters.remove('Main Street U.S.A');
          break;

        case 'Frontierland':
          filteredDisneylandAttractions = filteredDisneylandAttractions
              .where((attraction) => attraction.secteur == 'Frontierland')
              .toList();
          selectedFilters.remove('Frontierland');
          break;

        case 'Adventureland':
          filteredDisneylandAttractions = filteredDisneylandAttractions
              .where((attraction) => attraction.secteur == 'Adventureland')
              .toList();
          selectedFilters.remove('Adventureland');
          break;

        case 'Fantasyland':
          filteredDisneylandAttractions = filteredDisneylandAttractions
              .where((attraction) => attraction.secteur == 'Fantasyland')
              .toList();
          selectedFilters.remove('Fantasyland');

        case 'Discoveryland':
          filteredDisneylandAttractions = filteredDisneylandAttractions
              .where((attraction) => attraction.secteur == 'Discoveryland')
              .toList();
          selectedFilters.remove('Discoveryland');

// filtrage des land par Disney Studio
        case 'Toon Studio':
          filteredStudioAttractions = filteredStudioAttractions
              .where((attraction) => attraction.secteur == 'Toon Studio')
              .toList();
          selectedFilters.remove('Toon Studio');

        case 'Marvel Avengers Campus':
          filteredStudioAttractions = filteredStudioAttractions
              .where((attraction) =>
                  attraction.secteur == 'Marvel Avengers Campus')
              .toList();
          selectedFilters.remove('Marvel Avengers Campus');

        case 'Production Courtyard':
          filteredStudioAttractions = filteredStudioAttractions
              .where(
                  (attraction) => attraction.secteur == 'Production Courtyard')
              .toList();
          selectedFilters.remove('Production Courtyard');
      }
    }
  }
}

class FilterWidget extends StatelessWidget {
  final List<String>? selectedFilters;
  final Function(List<String>)? onFiltersChanged;

  const FilterWidget({super.key, this.selectedFilters, this.onFiltersChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07),
            child: const Text(
              'Filtres :',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.004),
          FilterButton(
            title: 'Temps d\'attente',
            filterKey: 'waitTime',
            selectedFilters: selectedFilters,
            onFiltersChanged: onFiltersChanged,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.004),
          FilterButton(
            title: 'Favoris',
            filterKey: 'favorites',
            selectedFilters: selectedFilters,
            onFiltersChanged: onFiltersChanged,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.004),
          FilterButton(
            title: 'Disponibles',
            filterKey: 'availability',
            selectedFilters: selectedFilters,
            onFiltersChanged: onFiltersChanged,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.004),
          FilterButton(
            title: 'Non disponibles',
            filterKey: 'non_availability',
            selectedFilters: selectedFilters,
            onFiltersChanged: onFiltersChanged,
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String title;
  final String filterKey;
  final List<String>? selectedFilters;
  final Function(List<String>)? onFiltersChanged;

  const FilterButton({
    super.key,
    required this.title,
    required this.filterKey,
    required this.selectedFilters,
    required this.onFiltersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          List<String> updatedFilters = List.from(selectedFilters ?? []);
          if (updatedFilters.contains(filterKey)) {
            updatedFilters.remove(filterKey);
          } else {
            updatedFilters.add(filterKey);
          }
          debugPrint('Updated filters: $updatedFilters');
          if (onFiltersChanged != null) {
            onFiltersChanged!(updatedFilters);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedFilters != null && selectedFilters!.contains(filterKey)
                  ? Colors.green
                  : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color:
                selectedFilters != null && selectedFilters!.contains(filterKey)
                    ? Colors.white
                    : Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
