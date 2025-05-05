import 'dart:io';
import 'package:bicopi_affiliate/verifikasi_email.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';
import 'points.dart';
import 'notifikasi.dart';
import 'ubah_password.dart';

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
  final User? _user = Supabase.instance.client.auth.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late Future<void> _userFuture;
  File? _pickedImage;

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => VerifikasiEmailScreen(
            email:'ke Email Anda'),
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      Widget nextScreen;
      if (index == 0) {
        nextScreen = const HomeScreen();
      } else if (index == 1) {
        nextScreen = const PointsScreen();
      } else if (index == 2) {
        nextScreen = const NotificationScreen();
      } else {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
      );
    }
  }

  Future<void> _fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final metadata = user.userMetadata ?? {};
      _nameController.text = metadata['username'] ?? 'Nama Tidak Diketahui';
      _emailController.text = user.email ?? 'Email Tidak Diketahui';
    }
  }

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        // Redirect ke halaman verifikasi email kalau belum login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifikasiEmailScreen(
                email: ''), // Ganti dengan email user yang sebenarnya jika perlu
          ),
        );
      }
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
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : const AssetImage('assets/profil.png')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: _userFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                          children: [
                            Text(
                              _nameController.text,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              _emailController.text,
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.grey[700]),
                            ),
                          ],
                        );
                      }
                    },
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
                  buildTextField('Full Name', _nameController),
                  const SizedBox(height: 8),
                  buildTextField('Email', _emailController),
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
                        builder: (context) => const UbahPasswordScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            buildProfileSection(
              title: 'Tentang Aplikasi',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Syarat & Ketentuan',
                    style: GoogleFonts.poppins(fontSize: 14)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsAndConditionsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _logout,
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
        onTap: _onTabTapped,
        items: const [
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

// Widget tambahan
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

Widget buildTextField(String label, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
      const SizedBox(height: 4),
      SizedBox(
        height: 38,
        child: TextField(
          controller: controller,
          readOnly: true,
          style: GoogleFonts.poppins(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    ],
  );
}

// Halaman Syarat & Ketentuan
class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _isIndonesian = true;

  void _toggleLanguage(bool isIndo) {
    setState(() {
      _isIndonesian = isIndo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isIndonesian ? 'Syarat & Ketentuan' : 'Terms & Conditions',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _toggleLanguage(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isIndonesian ? Colors.green : Colors.grey,
                  ),
                  child: const Text('Indonesia 🇮🇩'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _toggleLanguage(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !_isIndonesian ? Colors.green : Colors.grey,
                  ),
                  child: const Text('English 🇬🇧'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _isIndonesian
                  ? 'Selamat datang di aplikasi Affiliate BiCOPI!'
                  : 'Welcome to the BiCOPI Affiliate App!',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children:
                    _isIndonesian ? _buildTermsIndo() : _buildTermsEnglish(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTermsIndo() => [
        _buildTermsItem('1. Pendaftaran Program',
            'Setiap calon afiliasi harus mengisi formulir pendaftaran...'),
        _buildTermsItem('2. Kualifikasi Afiliasi',
            'Terbuka untuk individu atau badan usaha...'),
        _buildTermsItem('3. Tautan Afiliasi dan Materi Promosi',
            'Afiliasi akan menerima tautan afiliasi unik...'),
        _buildTermsItem(
            '4. Komisi', 'Afiliasi akan mendapatkan komisi sebesar [xx]%...'),
        _buildTermsItem('5. Pelaporan dan Pembayaran',
            'Data transaksi tersedia di dashboard...'),
        _buildTermsItem('6. Kewajiban Afiliasi',
            'Afiliasi wajib memberikan informasi yang benar...'),
        _buildTermsItem('7. Hak BiCOPI',
            'BiCOPI berhak memperbarui, menghentikan, atau mengubah...'),
        _buildTermsItem('8. Batasan Tanggung Jawab',
            'BiCOPI tidak bertanggung jawab atas kerugian...'),
        _buildTermsItem('9. Ketentuan Umum',
            'Dengan mengikuti program ini, afiliasi menyetujui tunduk pada hukum...'),
      ];

  List<Widget> _buildTermsEnglish() => [
        _buildTermsItem('1. Program Registration',
            'Each affiliate applicant must fill out the registration form...'),
        _buildTermsItem('2. Affiliate Qualification',
            'Open to individuals or entities with digital platforms...'),
        _buildTermsItem('3. Affiliate Links and Promotional Materials',
            'Affiliates will receive a unique affiliate link...'),
        _buildTermsItem(
            '4. Commission', 'Affiliates will earn a commission of [xx]%...'),
        _buildTermsItem('5. Reporting and Payment',
            'Transaction data is available on the dashboard...'),
        _buildTermsItem('6. Affiliate Obligations',
            'Affiliates must provide accurate information...'),
        _buildTermsItem('7. BiCOPI Rights',
            'BiCOPI reserves the right to update, terminate, or modify...'),
        _buildTermsItem('8. Limitation of Liability',
            'BiCOPI shall not be liable for indirect losses...'),
        _buildTermsItem('9. General Provisions',
            'By participating, the affiliate agrees to comply with the laws...'),
      ];

  Widget _buildTermsItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        const SizedBox(height: 6),
        Text(content,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 16),
      ],
    );
  }
}
