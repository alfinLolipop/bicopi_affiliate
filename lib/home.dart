import 'package:bicopi_affiliate/profil.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'notifikasi.dart';
import 'profil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PromoScreen()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WithdrawBalancePage()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Halo User",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Siap hasilkan komisi hari ini?",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotifikasiScreen()),
                      );
                    },
                    child: Icon(Icons.notifications, color: Colors.green, size: 28),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Card untuk Data Hari Ini
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TotalPendapatanScreen()),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Data Hari ini", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(flex: 2, child: _infoTile(Icons.bar_chart, "Rp 300k", "Pendapatan")),
                            Expanded(flex: 1, child: _infoTile(Icons.monetization_on, "5", "Poin")),
                            Expanded(flex: 2, child: _infoTile(Icons.trending_up, "Rp 200k", "Komisi")),
                            Expanded(flex: 1, child: _infoTile(Icons.autorenew, "5", "Share")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Grafik Tren Penjualan
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Grafik Tren Penjualan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      SizedBox(height: 150, child: LineChart(_lineChartData())),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Top Affiliate DI LUAR KOTAK
              _topAffiliateSection(),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar dengan Curved Effect
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.grey[300]!,
        buttonBackgroundColor: Colors.green,
        height: 60,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: _selectedIndex == 0 ? Colors.white : Colors.green),
          Icon(Icons.menu_book, size: 30, color: _selectedIndex == 1 ? Colors.white : Colors.green),
          Icon(Icons.credit_card, size: 30, color: _selectedIndex == 2 ? Colors.white : Colors.green),
          Icon(Icons.person, size: 30, color: _selectedIndex == 3 ? Colors.white : Colors.green),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
        animationDuration: Duration(milliseconds: 300),
      ),
    );
  }

  Widget _infoTile(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 30),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  LineChartData _lineChartData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 730),
            FlSpot(1, 878),
            FlSpot(2, 1332),
            FlSpot(3, 957),
            FlSpot(4, 152),
            FlSpot(5, 113),
            FlSpot(6, 97),
          ],
          isCurved: true,
          color: Colors.green,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  Widget _topAffiliateSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Top Affiliate", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
      SizedBox(height: 12),
      _topAffiliateItem(1, "Dimas Uyee", "1200", "assets/avatar1.png"),
      _topAffiliateItem(2, "Abah Pikri", "950", "assets/avatar2.png"),
      _topAffiliateItem(3, "Nabila", "870", "assets/avatar3.png"),
    ],
  );
}

Widget _topAffiliateItem(int rank, String name, String points, String avatarPath) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20),
    child: Row(
      children: [
        Text("$rank.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        CircleAvatar(
          radius: 20, // Ukuran gambar
          backgroundImage: AssetImage(avatarPath),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Text(
          "$points Pts",
          style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 10, 10, 10), fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
}