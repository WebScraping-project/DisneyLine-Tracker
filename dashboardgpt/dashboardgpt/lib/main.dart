import 'package:flutter/material.dart';
import 'liste_attractions.dart';
import 'attraction.dart';

void main() {
  runApp(const MyApp());
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
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Attraction> attractions;
  List<Attraction> filteredAttractions = [];
  List<Attraction> topAttractions = [];
  String selectedView = 'Disneyland';

  @override
  void initState() {
    super.initState();
    _loadAttractions();
  }

  Future<void> _loadAttractions() async {
    attractions = await parseAttractions();
    filteredAttractions = List.from(attractions);

    // Mettre à jour le top 3 des attractions
    _updateTopAttractions();

    setState(() {});
  }

  void _updateTopAttractions() {
    attractions.sort((a, b) => b.waitTime.compareTo(a.waitTime));
    topAttractions = attractions.take(3).toList();
  }

  void _onViewChanged(String? view) {
    setState(() {
      selectedView = view ?? 'Disneyland';
      if (view == 'Disneyland') {
        filteredAttractions = List.from(attractions);
      } else {
        filteredAttractions = attractions
            .where((attraction) => attraction.secteur == view)
            .toList();
      }

      // Mettre à jour le top 3 des attractions lors du changement de vue
      _updateTopAttractions();
    });
  }

  Widget buildTopAttractionsContainer() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(
            maxHeight: double.infinity), // Contrainte verticale
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
              'Top 3 Attractions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 10.0),
            for (var attraction in topAttractions)
              ListTile(
                title: Text(attraction.name),
                subtitle: Text(
                  'Temps d\'attente: ${attraction.waitTime} minutes',
                ),
                trailing: Icon(
                  attraction.isAvailable ? Icons.check_circle : Icons.cancel,
                  color: attraction.isAvailable ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildAttractionsInfoContainer() {
    int totalAttractions = attractions.length;
    int availableAttractions =
        attractions.where((attraction) => attraction.isAvailable).length;

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
            fontSize: 15.0,
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
          child: const Center(
            child: Text(
              'Disneyline Tracker',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          // Partie gauche avec la liste des attractions
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              // ignore: unnecessary_null_comparison
              child: attractions == null
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
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
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 300),
                                child: DropdownButton<String>(
                                  value: selectedView,
                                  onChanged: _onViewChanged,
                                  isExpanded: true,
                                  elevation: 5,
                                  items: [
                                    'Disneyland',
                                    'Main Street U.S.A',
                                    'Frontierland',
                                    'Adventureland',
                                    'Fantasyland',
                                    'Discoveryland',
                                  ].map((String view) {
                                    return DropdownMenuItem<String>(
                                      value: view,
                                      child: Center(
                                        child: Text(
                                          view,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  underline: Container(),
                                ),
                              ),
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
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 158, 158, 158)
                                                .withOpacity(0.2),
                                            spreadRadius: 0.1,
                                            blurRadius: 0,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
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
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          // Partie droite avec le top 3 des attractions et les informations sur les attractions
          Container(
            width: 400.0, // Ajustez la largeur selon vos besoins
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildAttractionsInfoContainer(),
                const SizedBox(
                    height: 16.0), // Espacement entre les deux containers
                buildTopAttractionsContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
