import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'place_profile.dart'; 
import 'person_Profile.dart';
import 'search_results.dart';
import 'type_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> resData = [];

  @override
  void initState() {
    super.initState();
    _fetchResData();
  }

 Future<void> _fetchResData() async {
  try {
    QuerySnapshot querySnapshot = await _firestore.collection('restaurant').get();
    print('Number of Restaurants fetched: ${querySnapshot.docs.length}');

    setState(() {
      resData = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?; 
        return {
          'id': doc.id,
          'imageUrl': data?['image'] ?? 'assets/res3.jpg',
          'name': data?['name'] ?? 'Unknown',
          'rating': data?['rating']?.toString() ?? 'Unknown',
          'distance': data?['distance']?.toString() ?? '0', 
        };
      }).toList();

      resData.sort((a, b) {
        double distanceA = double.tryParse(a['distance']) ?? 0;
        double distanceB = double.tryParse(b['distance']) ?? 0;

        return distanceA.compareTo(distanceB); 
      });
    });
  } catch (e) {
    print('Error fetching data: $e');
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 226, 248, 232),
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Container(
       
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (text) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResults(query: text),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecommendedItem(context, 'Pizza', 'assets/pizza2.jpg'),
                  _buildRecommendedItem(context, 'Burger', 'assets/burger2.jpg'),
                  _buildRecommendedItem(context, 'Cafe', 'assets/icafe.jpg'),
                  _buildRecommendedItem(context, 'Restaurant', 'assets/res.png'),
                  _buildRecommendedItem(context, 'Bar', 'assets/bar.jpg'),
                ],
              ),
            ),
            const Text(
              "Recommended",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                
                itemCount: resData.length,
                itemBuilder: (context, index) {
                  final itemData = resData[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceProfile(restaurantId: itemData['id']),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 64,
                          minHeight: 64,
                          maxWidth: 64,
                          maxHeight: 64,
                        ),
                        child: Image.asset(
                          itemData['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      //tileColor: Color.fromARGB(255, 244, 250, 244),
                      title: Text(itemData['name']),
                      subtitle:  Text('${itemData['distance']} km'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(itemData['rating']),
                          const SizedBox(width: 5),
                          const Icon(Icons.star, color: Colors.yellow),
                          
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedItem(BuildContext context, String name, String img) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TypePage(restaurantType: name),
          ),
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(img),
            ),
            Text(name),
          ],
        ),
      ),
    );
  }
}
