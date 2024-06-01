import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'place_profile.dart';

class TypePage extends StatefulWidget {
  final String restaurantType;

  const TypePage({Key? key, required this.restaurantType}) : super(key: key);

  @override
  _TypePageState createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  late Future<List<Map<String, dynamic>>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = _fetchSearchResults(widget.restaurantType.toLowerCase());
  }

  Future<List<Map<String, dynamic>>> _fetchSearchResults(String type) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('restaurant')
        .where('type', isEqualTo: type)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.restaurantType), // Replaced with restaurantType
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final results = snapshot.data!;
          if (results.isEmpty) {
            return const Center(child: Text('No results found'));
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return InkWell(
                onTap: () {
                  debugPrint('Navigating to PlaceProfile with id: ${result['id']}'); // Add debug print
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceProfile(
                        restaurantId: result['id'],
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                      maxWidth: 64,
                      maxHeight: 64,
                    ),
                    child: Image.asset(
                      result['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(result['name']),
                  subtitle: Text('Distance: ${result['distance']} km'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(result['rating'].toString()),
                      const SizedBox(width: 5),
                      const Icon(Icons.star, color: Colors.yellow),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}