import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceProfile extends StatefulWidget {
  final String restaurantId;

  const PlaceProfile({required this.restaurantId});

  @override
  _PlaceProfileState createState() => _PlaceProfileState();
}

class _PlaceProfileState extends State<PlaceProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _commentController = TextEditingController();
  late Future<Map<String, dynamic>> _restaurantData;
  late Future<List<Map<String, dynamic>>> _foodData;
  late Future<List<Map<String, dynamic>>> _reviews;

  @override
  void initState() {
    super.initState();
    _restaurantData = _fetchRestaurantData();
    _foodData = _fetchFoodData();
    _reviews = _fetchReviews();
  }

  Future<Map<String, dynamic>> _fetchRestaurantData() async {
    final doc = await _firestore.collection('restaurant').doc(widget.restaurantId).get();
    return doc.data()!;
  }

  Future<List<Map<String, dynamic>>> _fetchFoodData() async {
    final querySnapshot = await _firestore.collection('foods')
        .where('id', isEqualTo: widget.restaurantId).get();
    return querySnapshot.docs.map((doc) => doc.data()..['docId'] = doc.id).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchReviews() async {
    final querySnapshot = await _firestore.collection('comments')
        .where('id', isEqualTo: widget.restaurantId).get();
    return querySnapshot.docs.map((doc) => doc.data()..['docId'] = doc.id).toList();
  }

  Future<String> _getUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc['email'];
    }
    return '';
  }

  void _addComment(String text) async {
    final userEmail = await _getUserEmail();
    if (userEmail.isNotEmpty) {
      await _firestore.collection('comments').add({
        'id': widget.restaurantId,
        'email': userEmail,
        'comment': text,
      });
      setState(() {
        _reviews = _fetchReviews();
      });
      _commentController.clear();
    }
  }

  void _deleteComment(String docId) async {
    await _firestore.collection('comments').doc(docId).delete();
    setState(() {
      _reviews = _fetchReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Profile'),
      ),
      body: FutureBuilder(
        future: Future.wait([_restaurantData, _foodData, _reviews]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final restaurantData = snapshot.data![0] as Map<String, dynamic>;
          final foodData = snapshot.data![1] as List<Map<String, dynamic>>;
          final reviews = snapshot.data![2] as List<Map<String, dynamic>>;

          return ListView(
            children: [
              if (restaurantData['image'] != null)
                Image.asset(
                  restaurantData['image'],
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantData['name'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange),
                        SizedBox(width: 4),
                        Text('${restaurantData['rating']}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('Working hours: ${restaurantData['working hours']}'),
                    Text('Distance: ${restaurantData['distance']} km'),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...foodData.map((food) => _buildMenuItem(
                food['name'],
                food['price'].toString(),
                food['image'],
              )),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Reviews',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildReviews(reviews),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  final text = _commentController.text;
                  if (text.isNotEmpty) {
                    _addComment(text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String name, String price, String img) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      title: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 44,
              minHeight: 44,
              maxWidth: 64,
              maxHeight: 64,
            ),
            child: Image.network(
              img,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            name,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      trailing: Text(
        price,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildReviews(List<Map<String, dynamic>> reviews) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ListTile(
          leading: Icon(Icons.person),
          title: Text(review['email']),
          subtitle: Text(review['comment']),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteComment(review['docId']);
            },
          ),
        );
      },
    );
  }
}
// import 'package:flutter/material.dart';

// final List<String> reviews = [
//   "Great food and fast delivery!",
//   "Loved the burgers here!",
//   "Excellent customer service.",
//   "Highly recommend the chicken wings.",
// ];

// final List<Map<String, String>> foodData = [
//   {
//     'name': 'Full Pizza',
//     'price': '450.8',
//     'img': 'assets/pizza.jpg', // Make sure the image file exists here
//   },
//   {
//     'name': 'Burger',
//     'price': '350.7',
//     'img': 'assets/burger.jpg', // Make sure the image file exists here
//   },
//   {
//     'name': 'Lasagna',
//     'price': '556',
//     'img': 'assets/las.jpg', // Make sure the image file exists here
//   },
//   // Add more items here...
// ];
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
//   },];
//   /* String _getRest(resData) {
//    String nameres ='${resData[0]['id']}';
//  for (var element in resData) {
   
//     int num=0;
//       if('${resData[0]['id']}'==1){
//         return nameres;
//       }
//       else 
//       return 'no name found';
//       }
//     if(num==1){
//         return nameres;
//       }
//       else 
//       return 'no name found';

// }*/
// class PlaceProfile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
        
//        // title: Text(_getRest(resData)),
        
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Figa Traffic Light'), // Update with actual name/location
//                 const Row(
//                   children: [
//                     Icon(Icons.star, color: Colors.orange),
//                     Text('4.0'), // Update with actual rating
//                     SizedBox(width: 10),
//                     Text('| Working Hours: 08:30-20:30 |'), // Update with hours
//                     SizedBox(width: 10),
//                     Text('Distance: 42 min'),
//                   ],
//                 ),
//                 const Divider(),
//                 _buildMenuItem('${foodData[0]['name']}', '${foodData[0]['price']}','${foodData[0]['img']}'),
//                  _buildMenuItem('${foodData[1]['name']}', '${foodData[1]['price']}','${foodData[1]['img']}'),
//                  _buildMenuItem('${foodData[2]['name']}', '${foodData[2]['price']}','${foodData[2]['img']}'),
//                 const Divider(),
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     "What people are saying",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 _buildReviews(),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Add a comment...',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: () {
//                   // Add comment functionality (optional)
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuItem(String name, String price, String img) {
//     return ListTile(
//       title: Row(
//         children: [
//           ConstrainedBox(
//             constraints: BoxConstraints(
//               minWidth: 44,
//               minHeight: 44,
//               maxWidth: 64,
//               maxHeight: 64,
//             ),
//             child: Image.asset(
//               '$img',
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(width: 8), // Add spacing between image and text
//           Text(name),
//         ],
//       ),
//       trailing: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Text(price, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//         ],
//       ),
//       onTap: () {
//         // Add to cart functionality (optional)
//       },
//     );
//   }

//  Widget _buildReviews() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: reviews.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           leading: Icon(Icons.person),
//           title: Text(reviews[index]),
//         );
//       },
//     );
//   }
// }