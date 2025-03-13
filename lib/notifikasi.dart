import 'package:flutter/material.dart';

void main() {
  runApp(NotificationApp());
}

class NotificationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> todayNotifications = [
    {'title': 'Imbalan Komisi', 'message': 'Anda menerima komisi Rp. 5000 dari pesanan #123', 'time': '2 jam yang lalu', 'icon': 'money'},
    {'title': 'Hadiah Baru Tersedia', 'message': 'Anda telah membuka hadiah baru, klaim sekarang!', 'time': '5 jam yang lalu', 'icon': 'gift'},
  ];

  final List<Map<String, String>> yesterdayNotifications = [
    {'title': 'Referral Baru', 'message': 'John Doe bergabung menggunakan link referral anda', 'time': 'kemarin jam 02.30 siang', 'icon': 'person'},
    {'title': 'Pembaruan Kinerja', 'message': 'Penjualan Anda meningkat sebesar 15% minggu ini', 'time': 'kemarin jam 10.00 pagi', 'icon': 'chart'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 2), // Ukuran lebih besar untuk garis hijau
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {},
              ),
              title: Text('Notifikasi', style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 0, // Hapus shadow default
            ),
            Container(
              height: 2, // Garis hijau
              color: Colors.green,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          buildSectionTitle('Hari ini'),
          ...todayNotifications.map((notif) => buildNotificationCard(notif)).toList(),
          SizedBox(height: 16),
          buildSectionTitle('Kemarin'),
          ...yesterdayNotifications.map((notif) => buildNotificationCard(notif)).toList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Indeks notifikasi aktif
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Points'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
    );
  }

  Widget buildNotificationCard(Map<String, String> notif) {
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
          Icon(getIcon(notif['icon']!), size: 24, color: Colors.black54),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif['title']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(notif['message']!, style: TextStyle(fontSize: 14)),
                SizedBox(height: 4),
                Text(notif['time']!, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData getIcon(String iconName) {
    switch (iconName) {
      case 'money':
        return Icons.attach_money;
      case 'gift':
        return Icons.card_giftcard;
      case 'person':
        return Icons.person_add;
      case 'chart':
        return Icons.bar_chart;
      default:
        return Icons.notifications;
    }
  }
}
