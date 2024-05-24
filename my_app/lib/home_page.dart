import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("See All", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.kitchen),
                    title: Text('Kitchen'),
                    subtitle: Text('1km\n4.5'),
                    trailing: Icon(Icons.star, color: Colors.yellow),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text("Recommended", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecommendedItem('Catering', 4.5),
                  _buildRecommendedItem('Pizza', 4.5),
                  _buildRecommendedItem('Burger', 4.5),
                  _buildRecommendedItem('Cafe', 4.5),
                  _buildRecommendedItem('Restaurant', 4.5),
                  _buildRecommendedItem('Bar', 4.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedItem(String name, double rating) {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Icon(Icons.restaurant, size: 50),
          Text(name),
          Text('$rating', style: TextStyle(color: Colors.yellow)),
        ],
      ),
    );
  }
}