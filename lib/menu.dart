import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PromoScreen(),
    );
  }
}

class PromoScreen extends StatelessWidget {
  final List<Map<String, String>> products = [
    {
      'name': 'Nasi Kare Ayam',
      'image': 'assets/nasi_kare.jpg',
      'price': 'Rp. 24.000',
    },
    {
      'name': 'Strawberry Milkshake',
      'image': 'assets/strawberry_milkshake.jpg',
      'price': 'Rp. 24.000',
    },
    {
      'name': 'Cireng',
      'image': 'assets/cireng.jpg',
      'price': 'Rp. 24.000',
    },
    {
      'name': 'Nasi Sayur',
      'image': 'assets/nasi_sayur.jpg',
      'price': 'Rp. 24.000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text('Produk Promo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Your Product',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(product: products[index]),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(products[index]['image']!, fit: BoxFit.cover, height: 120, width: double.infinity),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                color: Colors.red,
                                padding: EdgeInsets.all(5),
                                child: Text('Diskon 20%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(products[index]['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(products[index]['price']!, style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar dengan Curved Effect
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.grey[300]!,
        buttonBackgroundColor: Colors.green,
        height: 60,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.green),
          Icon(Icons.menu_book, size: 30, color: Colors.green),
          Icon(Icons.credit_card, size: 30, color: Colors.green),
          Icon(Icons.person, size: 30, color: Colors.green),
        ],
        index: 0,
        onTap: (index) {},
        animationDuration: Duration(milliseconds: 300),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Map<String, String> product;

  DetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(product['image']!, height: 200),
            SizedBox(height: 20),
            Text(product['name']!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(product['price']!, style: TextStyle(fontSize: 20, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
