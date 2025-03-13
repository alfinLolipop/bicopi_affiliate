import 'package:bicopi_affiliate/member.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Points'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Halo Dimas',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/logo_bicopi.png'),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Container(height: 2, color: Colors.green),
                SizedBox(height: 20),
                _buildPointsCard(),
                SizedBox(height: 20),
                _buildRiwayatKomisi(),
                SizedBox(height: 20),
                _buildMembersList(context), // Menambahkan context untuk navigasi
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100, width: 1),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Point Saat Ini',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          SizedBox(height: 2),
          Text(
            '2500',
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatKomisi() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Riwayat Komisi', style: GoogleFonts.poppins(fontSize: 14)),
              DropdownButton<String>(
                value: 'Daily',
                items: ['Daily', 'Weekly', 'Monthly']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {},
              ),
            ],
          ),
          SizedBox(height: 50),
          Center(child: Text('Tempat Grafik', style: GoogleFonts.poppins(color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildMembersList(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Members',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                'Total: 100',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
              ),
            ],
          ),
          SizedBox(height: 12),
          MemberItem(name: 'John Doe', date: '15 Februari 2025', image: 'assets/john.png'),
          MemberItem(name: 'Sarah Smith', date: '14 Februari 2025', image: 'assets/sarah.png'),
          MemberItem(name: 'Ashley Smith', date: '13 Februari 2025', image: 'assets/ashley.png'),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemberScreen()),
                );
              },
              child: Text(
                'Lihat Semua Member',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class MemberItem extends StatelessWidget {
  final String name;
  final String date;
  final String image;

  const MemberItem({required this.name, required this.date, required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(radius: 20, backgroundImage: AssetImage(image)),
      title: Text(
        name,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      subtitle: Text(
        'Bergabung $date',
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
      ),
    );
  }
}
