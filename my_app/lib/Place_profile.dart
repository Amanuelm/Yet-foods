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
        .where('rid', isEqualTo: widget.restaurantId).get();
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
        backgroundColor: const Color.fromARGB(255, 226, 248, 232),
        title: const Text('Place Profile'),
      ),
      body: FutureBuilder(
        future: Future.wait([_restaurantData, _foodData, _reviews]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text('${restaurantData['rating']}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Working hours: ${restaurantData['working hours']}'),
                    Text('Distance: ${restaurantData['distance']} km'),
                  ],
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
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
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
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
                icon: const Icon(Icons.send),
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
            constraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
              maxWidth: 64,
              maxHeight: 64,
            ),
            child: Image.asset(
              '$img.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
      trailing: Text(
        price+" Birr",
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildReviews(List<Map<String, dynamic>> reviews) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(review['email']),
          subtitle: Text(review['comment']),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteComment(review['docId']);
            },
          ),
        );
      },
    );
  }
}
