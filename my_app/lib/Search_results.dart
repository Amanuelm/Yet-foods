import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'place_profile.dart';

class SearchResults extends StatefulWidget {
  final String query;

  const SearchResults({Key? key, required this.query}) : super(key: key);

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    try {
      final querySnapshot = await _firestore
          .collection('restaurant')
          .where('name', isGreaterThanOrEqualTo: widget.query)
          .where('name', isLessThanOrEqualTo: widget.query + '\uf8ff')
          .get();

      setState(() {
        _results = querySnapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 226, 248, 232),
        title: const Text('Search Results'),
        
      ),
      
      body: Container(
   // Set your desired background color here
  padding: const EdgeInsets.all(16.0), // Adjust padding values as needed
  child: _isLoading
    ? const Center(child: CircularProgressIndicator())
    : _hasError
      ? const Center(child: Text('Error loading search results'))
      : _results.isEmpty
        ? const Center(child: Text('No results found'))
        : ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, index) {
              final result = _results[index];

              return InkWell(
                onTap: () {
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
                                  minWidth: 64,
                                  minHeight: 64,
                                  maxWidth: 64,
                                  maxHeight: 64,
                                ),
                                child: Image.asset(
                                        result['image'],
                                        fit: BoxFit.cover,
                                      )
                                    
                              ),
                              title: Text(result['name'] ?? 'Unknown'),
                              subtitle: Text('${result['distance'] ?? 'Unknown'} km'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(result['rating']?.toString() ?? 'N/A'),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.star, color: Colors.yellow),
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

