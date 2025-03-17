import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'points.dart';
import 'notifikasi.dart';
import 'ubah_password.dart'; // Pastikan file ini ada

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(color: Colors.green, height: 2.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'John Doe',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'JohnDoe@gmail.com',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                    icon: const Icon(Icons.copy, size: 14),
                    label: Text('Copy affiliate link',
                        style: GoogleFonts.poppins(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            buildProfileSection(
              title: 'Informasi akun',
              child: Column(
                children: [
                  buildTextField('Full Name', 'John Doe'),
                  const SizedBox(height: 8),
                  buildTextField('Email', 'JohnDoe@gmail.com'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            buildProfileSection(
              title: 'Keamanan',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Ubah Password',
                    style: GoogleFonts.poppins(fontSize: 14)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const UbahPasswordScreen()), // Navigasi ke halaman Ubah Password
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
              icon: const Icon(Icons.logout),
              label: Text('Logout', style: GoogleFonts.poppins(fontSize: 14)),
            ),
          ],
        ),
      ),
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
            } else if (index == 1) {
              nextScreen = const PointsScreen();
            } else if (index == 2) {
              nextScreen = const NotificationScreen();
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
}

Widget buildProfileSection({required String title, required Widget child}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600])),
        const SizedBox(height: 6),
        child,
      ],
    ),
  );
}

Widget buildTextField(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
      const SizedBox(height: 4),
      SizedBox(
        height: 38, // 🔹 Ukuran input lebih kecil
        child: TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          style: GoogleFonts.poppins(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 8), // 🔹 Mengurangi padding
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
          ),
        ),
      ),
    ],
  );
}
