import 'package:flutter/material.dart';

final List<String> reviews = [
  "Great food and fast delivery!",
  "Loved the burgers here!",
  "Excellent customer service.",
  "Highly recommend the chicken wings.",
];

final List<Map<String, String>> foodData = [
  {
    'name': 'Full Pizza',
    'price': '450.8',
    'img': 'assets/pizza.jpg', // Make sure the image file exists here
  },
  {
    'name': 'Burger',
    'price': '350.7',
    'img': 'assets/burger.jpg', // Make sure the image file exists here
  },
  {
    'name': 'Lasagna',
    'price': '556',
    'img': 'assets/las.jpg', // Make sure the image file exists here
  },
  // Add more items here...
];
final List<Map<String, String>> resData = [
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
  /* String _getRest(resData) {
   String nameres ='${resData[0]['id']}';
 for (var element in resData) {
   
    int num=0;
      if('${resData[0]['id']}'==1){
        return nameres;
      }
      else 
      return 'no name found';
      }
    if(num==1){
        return nameres;
      }
      else 
      return 'no name found';

}*/
class PlaceProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
       // title: Text(_getRest(resData)),
        
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Figa Traffic Light'), // Update with actual name/location
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange),
                    Text('4.0'), // Update with actual rating
                    SizedBox(width: 10),
                    Text('| Working Hours: 08:30-20:30 |'), // Update with hours
                    SizedBox(width: 10),
                    Text('Distance: 42 min'),
                  ],
                ),
                const Divider(),
                _buildMenuItem('${foodData[0]['name']}', '${foodData[0]['price']}','${foodData[0]['img']}'),
                 _buildMenuItem('${foodData[1]['name']}', '${foodData[1]['price']}','${foodData[1]['img']}'),
                 _buildMenuItem('${foodData[2]['name']}', '${foodData[2]['price']}','${foodData[2]['img']}'),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "What people are saying",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildReviews(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
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
                  // Add comment functionality (optional)
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
      title: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 44,
              minHeight: 44,
              maxWidth: 64,
              maxHeight: 64,
            ),
            child: Image.asset(
              '$img',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8), // Add spacing between image and text
          Text(name),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(price, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
      onTap: () {
        // Add to cart functionality (optional)
      },
    );
  }

 Widget _buildReviews() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.person),
          title: Text(reviews[index]),
        );
      },
    );
  }
}