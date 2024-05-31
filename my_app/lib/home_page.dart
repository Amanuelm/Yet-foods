// 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'place_profile.dart'; // Ensure this import is correct
import 'Person_Profile.dart';
import 'Search_results.dart';

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
    print('Number of Restaurants fetched: ${querySnapshot.docs.length}'); // Added print statement

    setState(() {
      resData = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'imageUrl': doc['image'] ?? 'assets/res3.jpg',
          'name': doc['name'],
          'rating': doc['rating'].toString(),
        };
      }).toList();
    });
  } catch (e) {
    print('Error fetching data: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.person), // Replace with your desired icon
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
        color: Colors.white,
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
                // Navigate to Search Results Page with the entered text
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResults(res: text),
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
                  _buildRecommendedItem('Pizza', 'assets/pizza2.jpg'),
                  _buildRecommendedItem('Burger', 'assets/burger2.jpg'),
                  _buildRecommendedItem('Cafe', 'assets/icafe.jpg'),
                  _buildRecommendedItem('Restaurant', 'assets/res.png'),
                  _buildRecommendedItem('Bar', 'assets/bar.jpg'),
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
                        constraints: BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                          maxWidth: 64,
                          maxHeight: 64,
                        ),
                        child: Image.asset(
                          itemData['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      tileColor: Color.fromARGB(255, 64, 95, 65),
                      title: Text(itemData['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(itemData['rating']),
                          SizedBox(width: 5),
                          Icon(Icons.star, color: Colors.yellow),
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

  Widget _buildRecommendedItem(String name, String img) {
    return Container(
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
    );
  }
}

//
//// home.dart
// import 'package:flutter/material.dart';
// import 'package:my_app/Search_results.dart';
// import 'place_profile.dart'; // Make sure to import the PlaceProfile widget
// import 'Person_Profile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Map<String, dynamic>> resData = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchResData();
//   }

//   Future<void> _fetchResData() async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore.collection('restaurant').get();
//       setState(() {
//         resData = querySnapshot.docs.map((doc) {
//           return {
//             'id': 'asfd',
//             'imageUrl': 'assets/res3.jpg',
//             'name': doc['name'],
//             'Dis': '1km', // Placeholder for distance
//             'rating': doc['rating'],
//           };
//         }).toList();
//       });
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.person), // Replace with your desired icon
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProfilePage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               onSubmitted: (text) {
//                 // Navigate to Search Results Page with the entered text
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SearchResults(res: text),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               height: 120,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: [
//                   _buildRecommendedItem('Pizza', 'assets/pizza2.jpg'),
//                   _buildRecommendedItem('Burger', 'assets/burger2.jpg'),
//                   _buildRecommendedItem('Cafe', 'assets/icafe.jpg'),
//                   _buildRecommendedItem('Restaurant', 'assets/res.png'),
//                   _buildRecommendedItem('Bar', 'assets/bar.jpg'),
//                 ],
//               ),
//             ),
//             const Text(
//               "Recommended",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: resData.length,
//                 itemBuilder: (context, index) {
//                   final itemData = resData[index];
//                   return InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => PlaceProfile()),
//                       );
//                     },
//                     child: ListTile(
//                       leading: ConstrainedBox(
//                         constraints: BoxConstraints(
//                           minWidth: 44,
//                           minHeight: 44,
//                           maxWidth: 64,
//                           maxHeight: 64,
//                         ),
//                         child: Image.network(
//                           itemData['imageUrl'],
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       tileColor: Color.fromARGB(255, 64, 95, 65),
//                       title: Text(itemData['name']),
//                       subtitle: Text(itemData['Dis']),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(itemData['rating']),
//                           SizedBox(width: 5),
//                           Icon(Icons.star, color: Colors.yellow),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecommendedItem(String name, String img) {
//     return Container(
//       width: 100,
//       margin: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundImage: AssetImage(img),
//           ),
//           Text(name),
//         ],
//       ),
//     );
//   }
// }

// final List<Map<String, String>> resData = [
//   {
//     'imageUrl': 'assets/res2.jpg',
//     'title': 'Dagm',
//     'Dis': '2km',
//     'rating': '4.5',
//     'id':'3'
//   },
//   {
//     'imageUrl': 'assets/res1.jpg',
//     'title': 'Kitchen',
//     'Dis': '4km',
//     'rating': '4.5',
//     'id':'2'
//   },
//     {
//     'imageUrl': 'assets/res3.jpg',
//     'title': 'Anobie',
//     'Dis': '3km',
//     'rating': '1.5',
//     'id':'4'
//   },
//   {
//     'imageUrl': 'assets/res3.jpg',
//     'title': 'amanuel',
//     'Dis': '1km',
//     'rating': '5',
//     'id':'1'
//   },
//   // Add more items here...
// ];
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         actions: [
//     IconButton(
//       icon: Icon(Icons.person_2), // Replace with your desired icon
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ProfilePage()),
//         );
//       },
//     ),
//   ],
//       ),
//       body: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//   // ... other TextField properties
//   decoration: InputDecoration(
//     hintText: 'Search',
//     prefixIcon: const Icon(Icons.search),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8.0),
//     ),
//   ),
//   onSubmitted: (text) {
//     // Navigate to Search Results Page with the entered text
//     Navigator.push(
//       context,
//       MaterialPageRoute(
       
//         builder: (context) => SearchResults(res: text),
//       ),
//     );
//   },
// ),
//              const SizedBox(height: 20),
//             SizedBox(
//               height: 120,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: [
//                   _buildRecommendedItem('Pizza','assets/pizza2.jpg'),
//                   _buildRecommendedItem('Burger','assets/burger2.jpg'),
//                   _buildRecommendedItem('Cafe','assets/icafe.jpg'),
//                   _buildRecommendedItem('Restaurant','assets/res.png'),
//                   _buildRecommendedItem('Bar','assets/bar.jpg'),
//                 ],
//               ),
//             ),
//              const Text(
//               "Recommended",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 4, // Adjust this according to your actual item count
//                 itemBuilder: (context, index) {
//                  final itemData = resData[index]; 
                  
//                  return InkWell(
                    
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => PlaceProfile()),
//                       );
//                     },
                    
//                     child:  ListTile(
//                     leading: ConstrainedBox(
//                             constraints: BoxConstraints(
//                             minWidth: 44,
//                             minHeight: 44,
//                             maxWidth: 64,
//                             maxHeight: 64,
//                             ),
//                             child: Image.asset( '${itemData['imageUrl']}', fit: BoxFit.cover),
//                             ),
                    
//                     tileColor: Color.fromARGB(255, 64, 95, 65),
//                     title: Text('${itemData['title']}'),
//                     subtitle: Text('${itemData['Dis']}'),
//                     trailing:  Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                       Text('${itemData['rating']}'),
//                       SizedBox(width: 5), // Add some spacing
//                       Icon(Icons.star, color: Colors.yellow),
//                       const Divider(),
//                 ],
//               ),
//                     ),
                   
//                   );
//                 },
//               ),
//             ),
           
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecommendedItem(String name,String img) {
//     return Container(
//       width: 100,
//       margin: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Column(
//         children: [
//           CircleAvatar(
//                 radius:30, // Adjust radius as needed
//                 backgroundImage: AssetImage('$img'), 
//               ),
//         Text(name),
//         ],
//       ),
//     );
//   }
// }
