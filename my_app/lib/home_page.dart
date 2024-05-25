import 'package:flutter/material.dart';
import 'package:my_app/Search_results.dart';
import 'place_profile.dart'; // Make sure to import the PlaceProfile widget
import 'Person_Profile.dart';

final List<Map<String, String>> resData = [
  {
    'imageUrl': 'assets/res2.jpg',
    'title': 'Dagm',
    'Dis': '2km',
    'rating': '4.5',
    'id': '3'
  },
  {
    'imageUrl': 'assets/res2.jpg',
    'title': 'Dagm',
    'Dis': '2km',
    'rating': '4.5',
    'id': '3'
  },
  {
    'imageUrl': 'assets/res3.jpg',
    'title': 'Anobie',
    'Dis': '3km',
    'rating': '1.5',
    'id': '4'
  },
  {
    'imageUrl': 'assets/res3.jpg',
    'title': 'amanuel',
    'Dis': '1km',
    'rating': '5',
    'id': '1'
  },
  {
    'imageUrl': 'assets/res3.jpg',
    'title': 'amanuel',
    'Dis': '1km',
    'rating': '5',
    'id': '1'
  },
  {
    'imageUrl': 'assets/res2.jpg',
    'title': 'Dagm',
    'Dis': '2km',
    'rating': '4.5',
    'id': '3'
  },
  {
    'imageUrl': 'assets/res3.jpg',
    'title': 'amanuel',
    'Dis': '1km',
    'rating': '5',
    'id': '1'
  },
  {
    'imageUrl': 'assets/res2.jpg',
    'title': 'Dagm',
    'Dis': '2km',
    'rating': '4.5',
    'id': '3'
  },
  {
    'imageUrl': 'assets/res3.jpg',
    'title': 'amanuel',
    'Dis': '1km',
    'rating': '5',
    'id': '1'
  },
  // Add more items here...
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Color.fromARGB(25, 0, 79, 3), // Change the AppBar color
        actions: [
          IconButton(
            icon: Icon(Icons.person_2), // Replace with your desired icon
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
        color: Colors.white, // Set the background color of the entire screen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
             // color: Colors.lightBlueAccent, // Change the color of the search bar background
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                // ... other TextField properties
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
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
            ),
            const SizedBox(height: 20),
            Container(
             color: Color.fromARGB(25, 0, 79, 3), // Change the background color of the horizontal list
             // padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
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
            ),
            const SizedBox(height: 10), // Adjust spacing as needed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Recommended",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 23.0), // Adjust the padding as needed
                  child: Text(
                    "Rating",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Adjust spacing as needed
            Expanded(
              child: ListView.builder(
                itemCount: resData.length, // Adjust this according to your actual item count
                itemBuilder: (context, index) {
                  final itemData = resData[index];
                  final Color itemColor = _getItemColor(index);

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceProfile(),
                            ),
                          );
                        },
                        child: Container(
                          color: itemColor,
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 44,
                                minHeight: 44,
                                maxWidth: 64,
                                maxHeight: 64,
                              ),
                              child: Image.asset(
                                '${itemData['imageUrl']}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text('${itemData['title']}'),
                            subtitle: Text('${itemData['Dis']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${itemData['rating']}'),
                                SizedBox(width: 5), // Add some spacing
                                Icon(Icons.star, color: Colors.yellow),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getItemColor(int index) {
    // Define a set of colors to cycle through
    List<Color> colors = [
      Color.fromARGB(25, 0, 79, 3),
    ];
    return colors[index % colors.length]; // Cycle through the colors
  }

  Widget _buildRecommendedItem(String name, String img) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30, // Adjust radius as needed
            backgroundImage: AssetImage('$img'),
          ),
          Text(name),
        ],
      ),
    );
  }
}
