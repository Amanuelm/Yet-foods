import 'package:flutter/material.dart';
import 'place_profile.dart'; 

final List<Map<String, String>> results = [
  {
    'imageUrl': 'assets/res2.jpg',
    'title': 'Dagm',
    'Dis': '2km',
    'rating': '4.5',
    'id':'3'
  },
  {
    'imageUrl': 'assets/res1.jpg',
    'title': 'Kitchen',
    'Dis': '4km',
    'rating': '4.5',
    'id':'2'
  },
    {
    'imageUrl': 'assets/res3.jpg',
    'title': 'Anobie',
    'Dis': '3km',
    'rating': '1.5',
    'id':'4'
  },
  {
    'imageUrl': 'assets/res3.jpg',
    'title': 'amanuel',
    'Dis': '1km',
    'rating': '5',
    'id':'1'
  },];
class SearchResults extends StatelessWidget {
  final String res; // Replace 'SearchResult' with your data structure

  const SearchResults({Key? key, required this.res}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Search Results'),
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: res.isEmpty
            ? const Center(child: Text('No results found')) // Handle empty list case
            :ListView.builder(
                itemCount:res.length, // Adjust this according to your actual item count
                itemBuilder: (context, index) {
                 final result = results[index]; 
                  
                 return InkWell(
                    
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => PlaceProfile()),
                    //   );
                    // },
                    child:  ListTile(
                    leading: ConstrainedBox(
                            constraints: BoxConstraints(
                            minWidth: 44,
                            minHeight: 44,
                            maxWidth: 64,
                            maxHeight: 64,
                            ),
                            child: Image.asset( '${result['imageUrl']}', fit: BoxFit.cover),
                            ),
                    title: Text('${result['title']}'),
                    subtitle: Text('${result['Dis']}'),
                    trailing:  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Text('${result['rating']}'),
                      SizedBox(width: 5), // Add some spacing
                      Icon(Icons.star, color: Colors.yellow),
                ],
              ),
                    ),
                  );
                },
              ),
            
      ),
    );
  }
}