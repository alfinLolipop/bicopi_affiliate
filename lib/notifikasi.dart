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
      home: NotifikasiScreen(),
    );
  }
}

class NotifikasiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text("Notifikasi", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hari Ini", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildNotificationItem(),
              _buildNotificationItem(),
              _buildNotificationItem(),
              SizedBox(height: 16),
              Text("Kemarin", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildNotificationItem(),
              _buildNotificationItem(),
              _buildNotificationItem(),
              _buildNotificationItem(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/icon_money.png',
              width: 24,
              height: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Kode referral berhasil digunakan! Kamu mendapatkan Rp5.000 dari transaksi yang menggunakan kode referralmu.",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}