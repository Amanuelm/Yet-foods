import 'package:flutter/material.dart';

class SearchResults extends StatelessWidget {
  final List<Map<String, String>> results; // Replace 'SearchResult' with your data structure

  const SearchResults({Key? key, required this.results}) : super(key: key);

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
        child: results.isEmpty
            ? const Center(child: Text('No results found')) // Handle empty list case
            : ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  // Replace this with your widget to display each search result
                  return ListTile(
                    title: Text('${result['title']}'), // Assuming 'title' property in SearchResult
                    subtitle: Text('${result['dis']}'), // Assuming 'description' property
                  );
                },
              ),
      ),
    );
  }
}