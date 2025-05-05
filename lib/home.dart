import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'member.dart';
import 'detail_member.dart';
import 'points.dart';
import 'package:bicopi_affiliate/popup.dart';
import 'notifikasi.dart';
import 'profil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedFilter = 'Daily';
  String _userName = '...'; 

  @override
    void initState() {
      super.initState();
      _getUserData();
    }

 Future<void> _getUserData() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user != null) {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('username')
          .eq('id_user', user.id) 
          .maybeSingle();

      print('Data username: $response');

      if (response != null && response['username'] != null) {
        setState(() {
          _userName = response['username'];
        });
      } else {
        print('Username tidak ditemukan');
      }
    } catch (error) {
      print('Gagal mengambil data user: $error');
    }
  } else {
    print('User belum login');
  }
}

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Halo $_userName',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/logo_bicopi.png'),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.green,
            height: 2.0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                _buildPointsCard(),

                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade100, width: 1),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Riwayat Komisi',
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          DropdownButton<String>(
                            value: _selectedFilter,
                            items: ['Daily', 'Weekly', 'Monthly']
                                .map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value,
                                    style: GoogleFonts.poppins(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedFilter = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Tempat Grafik',
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                _buildMembersList(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });

            Widget nextScreen;
            if (index == 1) {
              nextScreen = const PointsScreen();
            } else if (index == 2) {
              nextScreen = const NotificationScreen();
            } else if (index == 3) {
              nextScreen = const ProfileScreen();
            } else {
              return;
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

  Widget _buildPointsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Point Saat Ini',
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
          SizedBox(height: 2),
          Text(
            '2500',
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
          ),
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
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                'Total: 100',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500),
              ),
            ],
          ),
          SizedBox(height: 12),
          MemberItem(
              name: 'John Doe',
              date: '15 Februari 2025',
              image: 'assets/profil.png'),
          MemberItem(
              name: 'Sarah Smith',
              date: '14 Februari 2025',
              image: 'assets/profil.png'),
          MemberItem(
              name: 'Ashley Smith',
              date: '13 Februari 2025',
              image: 'assets/profil.png'),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MemberScreen()),
                );
              },
              child: Text(
                'Lihat Semua Member',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
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

  const MemberItem(
      {required this.name, required this.date, required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(radius: 20, backgroundImage: AssetImage(image)),
      title: Text(
        name,
        style: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      subtitle: Text(
        'Bergabung $date',
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
      ),
    );
  }
}
