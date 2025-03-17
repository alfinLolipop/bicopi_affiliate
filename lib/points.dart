import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'points.dart';
import 'popup.dart';
import 'notifikasi.dart';
import 'profil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PointsScreen(),
    );
  }
}

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  _PointsScreen createState() => _PointsScreen();
}

class _PointsScreen extends State<PointsScreen> {
  int _currentIndex = 1;
  int currentPoints = 250; // Simpan jumlah poin pengguna

  final List<Map<String, dynamic>> rewards = [
    {"title": "Gratis Kopi", "points": 150},
    {"title": "Gratis Kopi", "points": 200},
    {"title": "Gratis Kopi", "points": 250},
    {"title": "Gratis Kopi", "points": 300},
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Points',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.green,
            height: 2.0,
          ),
        ),
      ),
      body: Column(
        children: [
          // Kotak "Point Saat Ini"
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Point Saat Ini",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  "$currentPoints",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ),

          // ListView Rewards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: rewards.length,
              itemBuilder: (context, index) {
                final reward = rewards[index];
                return _buildRewardCard(context, reward["title"], reward["points"]);
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            // Hanya navigasi jika halaman berbeda
            setState(() {
              _currentIndex = index;
            });

            Widget nextScreen;
            if (index == 0) {
              nextScreen = const HomeScreen();
            } else if (index == 2) {
              nextScreen = const NotificationScreen();
            } else if (index == 3) {
              nextScreen = const ProfileScreen();
            } else {
              return; // Jika di Home, jangan lakukan navigasi
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => nextScreen),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Points'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildRewardCard(BuildContext context, String title, int points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("Dapatkan kopi reguler gratis di lokasi kami", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("$points Points", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () => showRedeemDialog(context, title, points),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text("Klaim reward", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showRedeemDialog(BuildContext context, String title, int points) {
    if (currentPoints < points) {
      // Jika poin tidak cukup, tampilkan pop-up peringatan
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Poin Tidak Cukup"),
            content: const Text("Maaf, poin Anda tidak cukup untuk menukar reward ini."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Jika poin cukup, tampilkan konfirmasi penukaran
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Penukaran"),
          content: Text("Tukar $points poin untuk $title?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                
                // TIDAK MENGURANGI POIN DI UI (Karena ini ranah admin)

                String transactionId = generateUniqueId(); // Buat ID unik
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PopupPage(
                      title: title,
                      points: points,
                      transactionId: transactionId, // Kirim ID unik
                    ),
                  ),
                );
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk membuat ID unik
  String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
