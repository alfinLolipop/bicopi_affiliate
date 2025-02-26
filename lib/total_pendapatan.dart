import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TotalPendapatanScreen(),
    );
  }
}

class TotalPendapatanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text("Total Pendapatan"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("30 hari terakhir (22 mar 2024-22 apr 2024)"),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text("Kinerja Afiliasi", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("Jumlah Pendapatan", "Rp 300 ribu", true),
                _buildStatCard("Total poin", "2", false),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("Total Komisi", "125", false),
                _buildStatCard("Jumlah Share Produk", "2", true),
              ],
            ),
            SizedBox(height: 16),
            Text("Histori Share Dan Pendapatan", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildHistoryItem("Nasi Goreng Udang Dan Telur", "Dibuat 12 Februari 2025", "Rp. 24.000", "5 Koin"),
            _buildHistoryItem("Ice White Coffe", "Dibuat 12 Februari 2025", "Rp. 24.000", "5 Koin"),
            _buildHistoryItem("Nasi Goreng Udang Dan Telur", "Dibuat 12 Februari 2025", "Rp. 24.000", "5 Koin"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, bool isPositive) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, size: 14, color: isPositive ? Colors.green : Colors.red),
                SizedBox(width: 4),
                Text("${isPositive ? "15%" : "4%"}", style: TextStyle(color: isPositive ? Colors.green : Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String date, String price, String commission) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage("assets/sample_food.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(date, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 4),
                  Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.monetization_on, size: 14, color: Colors.black),
                      SizedBox(width: 4),
                      Text("Komisi $commission", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
